import json
import time
import os
from playwright.sync_api import sync_playwright, TimeoutError
import random

# 确保logs文件夹存在
if not os.path.exists('logs'):
    os.makedirs('logs')
    print("已创建logs文件夹用于存储日志文件。")

# 重试机制辅助函数
def retry_with_backoff(func, max_retries=3, base_delay=2, max_delay=10, timeout_multiplier=1.5):
    """
    带退避策略的重试机制
    :param func: 要执行的函数
    :param max_retries: 最大重试次数
    :param base_delay: 基础延迟时间(秒)
    :param max_delay: 最大延迟时间(秒)
    :param timeout_multiplier: 每次重试时超时时间的倍数
    """
    for attempt in range(max_retries + 1):
        try:
            return func(timeout_multiplier ** attempt)
        except TimeoutError as e:
            if attempt == max_retries:
                print(f"重试 {max_retries} 次后仍然失败，放弃操作。")
                raise e
            
            delay = min(base_delay * (2 ** attempt) + random.uniform(0, 1), max_delay)
            print(f"第 {attempt + 1} 次尝试失败，{delay:.1f}秒后重试...")
            time.sleep(delay)
        except Exception as e:
            # 非超时错误直接抛出
            raise e

def wait_for_network_idle(page, timeout=30000):
    """
    等待网络空闲，确保页面完全加载
    """
    try:
        page.wait_for_load_state('networkidle', timeout=timeout)
        print("网络已空闲，页面加载完成。")
    except TimeoutError:
        print("等待网络空闲超时，但继续执行...")

def safe_goto(page, url, max_retries=3):
    """
    安全的页面导航，带重试机制
    """
    def _goto(timeout_multiplier):
        timeout = int(60000 * timeout_multiplier)
        print(f"正在导航至: {url} (超时: {timeout/1000}秒)")
        page.goto(url, timeout=timeout)
        wait_for_network_idle(page)
        return True
    
    return retry_with_backoff(_goto, max_retries)

def safe_wait_for_selector(page, selector, max_retries=3, state='visible'):
    """
    安全的元素等待，带重试机制
    """
    def _wait(timeout_multiplier):
        timeout = int(60000 * timeout_multiplier)
        print(f"等待元素: {selector} (超时: {timeout/1000}秒)")
        page.wait_for_selector(selector, state=state, timeout=timeout)
        return True
    
    return retry_with_backoff(_wait, max_retries)

def safe_click(page, selector, max_retries=3):
    """
    安全的点击操作，带重试机制
    """
    def _click(timeout_multiplier):
        timeout = int(30000 * timeout_multiplier)
        print(f"点击元素: {selector} (超时: {timeout/1000}秒)")
        element = page.locator(selector)
        element.wait_for(state='visible', timeout=timeout)
        element.click(timeout=timeout)
        time.sleep(1)  # 点击后短暂等待
        return True
    
    return retry_with_backoff(_click, max_retries)

def check_network_speed(page):
    """
    简单的网络速度检测
    """
    start_time = time.time()
    try:
        # 尝试加载一个轻量级页面来测试网络速度
        page.goto("https://www.baidu.com", timeout=10000)
        load_time = time.time() - start_time
        
        if load_time < 2:
            print("✅ 网络状况良好")
            return "good"
        elif load_time < 5:
            print("⚠️ 网络速度一般，可能需要更多等待时间")
            return "medium"
        else:
            print("🐌 网络较慢，建议检查网络连接")
            return "slow"
    except:
        print("❌ 网络连接异常，请检查网络设置")
        return "poor"

def adaptive_timeout(base_timeout, network_status):
    """
    根据网络状况调整超时时间
    """
    multipliers = {
        "good": 1.0,
        "medium": 1.5,
        "slow": 2.0,
        "poor": 3.0
    }
    return int(base_timeout * multipliers.get(network_status, 2.0))

# --- 1. 读取配置文件 ---
try:
    with open('config.json', 'r', encoding='utf-8') as f:
        config = json.load(f)
    LOGIN_USERNAME = config['login']['username']
    LOGIN_PASSWORD = config['login']['password']
    TARGET_AVATAR_ID = config['settings']['target_avatar_id']
    print("✅ 配置文件加载成功")
except FileNotFoundError:
    print("❌ 未找到config.json配置文件，使用默认设置")
    LOGIN_USERNAME = "BJ101TC"
    LOGIN_PASSWORD = "009234"
    TARGET_AVATAR_ID = "410a1f0"
except Exception as e:
    print(f"❌ 配置文件读取错误: {e}，使用默认设置")
    LOGIN_USERNAME = "BJ101TC"
    LOGIN_PASSWORD = "009234"
    TARGET_AVATAR_ID = "410a1f0"

# --- 2. 读取JSON数据文件 ---
# 脚本将从用户输入的章节号读取对应的JSON文件

# 获取用户输入的章节号
chapter_section = input("请输入章节号（例如：1.1）: ").strip()
JSON_INPUT_FILE = f"data/{chapter_section}.json"

try:
    with open(JSON_INPUT_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
    slides_to_process = data.get('slides', [])
    print(f"成功加载 {len(slides_to_process)} 条幻灯片数据。")
except FileNotFoundError:
    print(f"错误：未找到数据文件 '{JSON_INPUT_FILE}'。请确保data目录下存在对应的JSON文件。")
    exit()
except json.JSONDecodeError:
    print(f"错误：'{JSON_INPUT_FILE}' 文件格式不正确。")
    exit()

def run(playwright):
    # --- 2. 启动浏览器 ---
    browser = playwright.chromium.launch(headless=False)
    # 创建一个浏览器上下文，所有页面都将从这里派生，共享登录状态
    context = browser.new_context()
    
    # --- 网络状况检测 ---
    print("\n🔍 正在检测网络状况...")
    test_page = context.new_page()
    network_status = check_network_speed(test_page)
    test_page.close()
    
    if network_status == "poor":
        print("⚠️ 网络连接异常，建议检查网络后重试。")
        response = input("是否继续执行？(y/n): ").strip().lower()
        if response != 'y':
            browser.close()
            return
    elif network_status in ["slow", "medium"]:
        print("💡 检测到网络较慢，程序将自动延长等待时间。")
    
    # --- 3. 登录流程 (在第一个临时页面上执行) ---
    print("步骤1-6：正在执行登录流程...")
    page = context.new_page()
    try:
        # 使用安全导航
        safe_goto(page, "https://marketingvideogen.com/admin#/login")
        
        # 等待登录表单加载
        safe_wait_for_selector(page, 'input[placeholder="您的用户名"]')
        
        # 【修正】根据实际页面情况，修正了placeholder文本
        print("填写登录信息...")
        page.locator('input[placeholder="您的用户名"]').fill(LOGIN_USERNAME)
        page.locator('input[placeholder="请输入密码"]').fill(LOGIN_PASSWORD)
        
        # 使用安全点击
        safe_click(page, 'button:has-text("登录")')
        
        # 等待登录成功
        safe_wait_for_selector(page, 'text=制作视频')
        print("登录成功！")
        
        # 获取登录后的主页URL，以便后续在新页面中直接访问
        dashboard_url = page.url
        print(f"已捕获主页URL: {dashboard_url}")
        
    except TimeoutError:
        print("登录失败或超时。网络可能较慢，请检查网络连接或稍后重试。")
        browser.close()
        return
    except Exception as e:
        print(f"登录过程中发生错误: {e}")
        browser.close()
        return
    finally:
        # 关闭这个临时的登录页面
        page.close()

    # --- 4. 循环处理每一张幻灯片 (每个任务使用一个新页面) ---
    print(f"\n🚀 开始处理 {len(slides_to_process)} 个视频任务...")
    print(f"网络状况: {network_status.upper()}")
    print("=" * 60)
    
    successful_count = 0
    failed_count = 0
    
    for i, slide in enumerate(slides_to_process):
        page = None # 初始化页面变量
        # 根据现有字段生成video_title - 格式：小高-章.节.节标题-页数
        video_title = f"小高-{slide['chapter']}.{slide['section']}.{slide['main_title']}-{slide['slide_number']}"
        video_script = slide['video_script']
        
        print(f"\n===== 开始处理第 {i+1}/{len(slides_to_process)} 个视频: {video_title} =====")
        
        try:
            # 为当前任务创建一个全新的页面
            print("为当前任务打开一个新页面...")
            page = context.new_page()
            
            # 直接访问主页，开始流程
            print(f"正在导航至主页: {dashboard_url}...")
            safe_goto(page, dashboard_url)
            safe_wait_for_selector(page, 'text=制作视频')

            # 步骤7-9: 从主页点击"制作视频"进入制作页面
            print("步骤7-9: 进入制作视频页面...")
            safe_click(page, 'text=制作视频')
            
            dialog_selector = "div.template-choose-dialog"
            # 【修正】根据我们之前的调试，按钮文本应为 "横屏 (16:9)"
            horizontal_button_selector = f'{dialog_selector} button:has-text("横屏")'

            print("等待'选择模板'弹窗出现...")
            safe_wait_for_selector(page, dialog_selector, state='visible')
            print("弹窗已出现。")

            page.screenshot(path=f'logs/debug_pre_click_{video_title}.png')
            print(f"已保存截图 'logs/debug_pre_click_{video_title}.png'")
            time.sleep(2)  # 增加等待时间确保弹窗完全加载

            # 步骤10：在弹窗内点击横屏模式
            print("步骤10: 正在点击'横屏'按钮...")
            safe_click(page, horizontal_button_selector)
            print("'横屏'按钮点击成功！")
            
            # 等待弹窗关闭和页面加载
            time.sleep(2)
            wait_for_network_idle(page)
            
            # 步骤11：输入内容
            print(f"步骤11: 输入主体内容 (共 {len(video_script)} 字)...")
            # 等待文本框出现
            safe_wait_for_selector(page, 'textarea[placeholder="请输入要合成的文本"]')
            page.locator('textarea[placeholder="请输入要合成的文本"]').fill(video_script)
            print("文本内容输入完成。")
            time.sleep(1)

            # 步骤12：选择主播栏
            print("步骤12: 选择主播栏...")
            safe_click(page, 'p:has-text("主播")')
            time.sleep(2)  # 等待主播选项加载

            # 步骤13：选择不同的主播形象
            print("步骤13: 选择主播形象...")
            avatar_selector = f'div.cell:has(img[src*="{TARGET_AVATAR_ID}"])'
            safe_wait_for_selector(page, avatar_selector)
            safe_click(page, avatar_selector)
            print("主播形象选择完成。")
            time.sleep(1)
            
            # 步骤14：直接修改标题内容
            print(f"步骤14: 直接修改标题为 '{video_title}'...")
            title_container_selector = 'div.header-left:has(div.left-title)'
            modify_script = f"""
                const container = document.querySelector('{title_container_selector}');
                if (container) {{
                    const titleElement = container.querySelector('div.left-title');
                    if (titleElement) {{
                        titleElement.textContent = '{video_title}';
                    }}
                }}
            """
            page.evaluate(modify_script)
            print("标题修改成功！")
            
            print(f"✅ 视频 {video_title} 内容填写完成!")
            successful_count += 1
            print(f"📊 进度: {successful_count + failed_count}/{len(slides_to_process)} (成功: {successful_count}, 失败: {failed_count})")

            # --- 5. (可选) 点击生成并返回 ---
            # ... (此处逻辑不变) ...
            
        except TimeoutError as e:
            print(f"\n❌ 错误：处理视频 {video_title} 时发生超时！")
            print(f"详细信息: {str(e)}")
            print("可能的原因:")
            print("  1. 网络连接较慢，页面加载时间过长")
            print("  2. 网站服务器响应缓慢")
            print("  3. 页面元素加载延迟")
            print("\n建议解决方案:")
            print("  1. 检查网络连接")
            print("  2. 稍后重试")
            print("  3. 如果问题持续，可能是网站服务器问题")
            
            if page:
                page.screenshot(path=f'logs/error_timeout_{video_title}.png')
                print(f"\n📸 已保存出错时的截图: 'logs/error_timeout_{video_title}.png'")
            
            failed_count += 1
            print(f"📊 进度: {successful_count + failed_count}/{len(slides_to_process)} (成功: {successful_count}, 失败: {failed_count})")
            print(f"\n⏭️ 跳过视频 '{video_title}'，继续处理下一个...")
            time.sleep(3)  # 给用户时间阅读错误信息
            continue
            
        except Exception as e:
            print(f"\n❌ 处理视频 {video_title} 时发生未知错误: {e}")
            print("\n建议解决方案:")
            print("  1. 检查网络连接")
            print("  2. 重启程序重试")
            print("  3. 如果问题持续，请联系技术支持")
            
            if page:
                page.screenshot(path=f'logs/error_unknown_{video_title}.png')
                print(f"\n📸 已保存出错时的截图: 'logs/error_unknown_{video_title}.png'")
            
            failed_count += 1
            print(f"📊 进度: {successful_count + failed_count}/{len(slides_to_process)} (成功: {successful_count}, 失败: {failed_count})")
            print(f"\n⏭️ 跳过视频 '{video_title}'，继续处理下一个...")
            time.sleep(3)  # 给用户时间阅读错误信息
            continue
        finally:
            # 任务完成后不再关闭页面
            if page:
                print(f"任务 '{video_title}' 已在页面上完成操作，页面将保持打开。")
            
    # --- 6. 所有任务完成后保持浏览器打开 ---
    print("\n" + "=" * 60)
    print("🎉 所有任务处理完毕！")
    print(f"\n📊 执行统计:")
    print(f"  ✅ 成功: {successful_count} 个视频")
    print(f"  ❌ 失败: {failed_count} 个视频")
    print(f"  📈 成功率: {(successful_count/(successful_count+failed_count)*100):.1f}%" if (successful_count+failed_count) > 0 else "  📈 成功率: 0%")
    
    if failed_count > 0:
        print(f"\n💡 失败的视频可以稍后重试，相关截图已保存在 logs 文件夹中。")
    
    print(f"\n🌐 网络状况: {network_status.upper()}")
    print("\n浏览器将保持打开状态供您检查。")
    print(">>> 请在此控制台窗口按 Enter 键以关闭浏览器。 <<<")
    input() # 这行代码会暂停脚本，直到您按下回车
    
    print("正在关闭浏览器...")
    browser.close() # 在您按下回车后，脚本会继续执行并关闭浏览器

# --- 启动器 ---
with sync_playwright() as playwright:
    run(playwright)
