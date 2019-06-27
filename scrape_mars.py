#Scott Otto Homework Module 12 - mission_to_mars - scraper element

# Dependencies
import os
import pandas as pd
from bs4 import BeautifulSoup
import requests
import pymongo
import time
from splinter import Browser

def init_browser():
    executable_path = {"executable_path": "/usr/local/bin/chromedriver"}
    return Browser("chrome", **executable_path, headless=True)

def scrape():
    browser = init_browser()

    nasa_url = "https://mars.nasa.gov/news/"
    browser.visit(nasa_url)
    time.sleep(1)
    html = browser.html
    nasa_soup = BeautifulSoup(html, 'html.parser')
    nasa_title = nasa_soup.find("div", class_ = "content_title").text
    nasa_para = nasa_soup.find("div", class_ = "rollover_description_inner").text


    jpl_url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(jpl_url)
    time.sleep(1)
    browser.click_link_by_partial_text("FULL IMAGE")
    time.sleep(3)
    browser.click_link_by_partial_text("more info")
    time.sleep(3)
    html = browser.html
    jpl_soup = BeautifulSoup(html, "html.parser")
    jpl_img = jpl_soup.find("img",class_ = "main_image")["src"]
    featured_image_url = "https://jpl.nasa.gov" + jpl_img


    mweather_url = "https://twitter.com/marswxreport?lang=en"
    browser
    browser.visit(mweather_url)
    time.sleep(1)
    html = browser.html
    mweather_response = requests.get(mweather_url)
    mweather_soup = BeautifulSoup(mweather_response.text, "lxml")
    mweather = mweather_soup.find("p", class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text").get_text()


    mfacts_url = "http://space-facts.com/mars/"
    mfacts_table = pd.read_html(mfacts_url)
    mfacts_df = mfacts_table[0]
    mfacts_df.columns = ["Description", "Value"]
    mfacts_df.set_index("Description", inplace=True)
    mfacts_html = mfacts_df.to_html()
    mfacts_html = mfacts_html.replace("\n", "")


    astro_url = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
    browser.visit(astro_url)
    time.sleep(1)
    html = browser.html
    astro_soup = BeautifulSoup(html, "html.parser")
    astro_links = []
    astro_titles = []
    astro_results = astro_soup.find_all("div", class_ = "item")
    for result in astro_results:
        astro_titles.append(result.find("h3").text)
        website = result.find("a", class_ = "itemLink product-item")["href"]
        astro_img_url = "https://astrogeology.usgs.gov" + website
        browser.visit(astro_img_url)
        html = browser.html
        astro_link_soup = BeautifulSoup(html, "html.parser")
        astro_links.append("https://astrogeology.usgs.gov" + astro_link_soup.find("img", class_ = "wide-image")["src"])
    hemisphere_image_urls = []
    for x in range(4):
        hemisphere_image_urls.append({"title": astro_titles[x], "img_url": astro_links[x]})

    mars_data = {
        "nasa_title": nasa_title,
        "nasa_para": nasa_para,
        "featured_image_url": featured_image_url,
        "mweather": mweather,
        "mfacts_html": mfacts_html,
        "hemisphere_image_urls": hemisphere_image_urls
    }

    browser.quit()

    return mars_data