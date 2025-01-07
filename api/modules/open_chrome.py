from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

try:
    options = Options()
    options.add_argument("--disable-gpu")  # Disable GPU acceleration
    options.add_argument("--no-sandbox")  # Required in some environments
    options.add_argument("--disable-dev-shm-usage")# Avoids out-of-memory issues# Set the correct path to chrome
    driver = webdriver.Chrome(service=ChromeDriverManager().install(), options=options)
    print("Chrome driver instantiated successfully in headless mode.")  # Set correct path to chromedriver
  
    driver.quit()
except Exception as e:
    print(f"Error: {e}")
