

def runScraper(driver, logic):
    yourScrapedData = []

    #### YOUR CODE HERE ####
    driver.get("https://www.google.de/")

    # Implement any scraping logic

    logic.message("Title: " + driver.title)
    #### YOUR CODE HERE ####

    return yourScrapedData