from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

try:
    options = Options()
    options.add_argument("--headless")
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)
    print("Chrome driver instantiated successfully in headless mode.")
    driver.quit()
except Exception as e:
    print(f"Error: {e}")
