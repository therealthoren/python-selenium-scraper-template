from selenium.webdriver import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webdriver import BaseWebDriver, WebDriver

from app.notifications.INotification import INotification
import time

def sleep(seconds):
    time.sleep(seconds)

def runScraper(driver: WebDriver, logic: INotification):
    yourScrapedData = []

    #### YOUR CODE HERE ####
    driver.get("https://www.google.de/")

    sleep(1)

    # find the button>div[contains(text(), '')]
    button = driver.find_elements(By.XPATH, "//div//button//div[contains(text(), 'All')]")
    if button is not None and len(button) > 0:
        button[0].click()

    sleep(2)

    # Implement any scraping logic
    textareas = driver.find_elements(By.XPATH, "//textarea")
    if textareas is not None and len(textareas) > 0:
        textareas[0].send_keys("Hello World")
        sleep(1)
        textareas[0].send_keys(Keys.ENTER)

    sleep(2)

    # click on the first link
    links = driver.find_elements(By.XPATH, "//span//h3")
    if links is not None and len(links) > 0:
        logic.message("Clicking on the first link: "+links[0].text)
        links[0].click()

    logic.message("Title: " + driver.title)
    #### YOUR CODE HERE ####

    sleep(2)

    return yourScrapedData