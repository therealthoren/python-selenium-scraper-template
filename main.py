from selenium import webdriver
from app.scraper import runScraper
from app.notifier import logic



def run():
    yourScrapedData = None

    ff_options = webdriver.FirefoxOptions()
    ff_options.add_argument('--no-sandbox')
    ff_options.add_argument('--disable-dev-shm-usage')

    try:
        # DONT CHANGE THIS LINE
        driver = webdriver.Remote("http://localhost:4444/wd/hub", options=ff_options)

        yourScrapedData = runScraper(driver, logic)


    except Exception as e:
        print(e)
        logic.crashed(e)
    finally:
        driver.quit()

    return yourScrapedData


try:
    logic.start()
    data = run()
    logic.finished(data)
except Exception as e:
    logic.crashed(e)
    print(e)

