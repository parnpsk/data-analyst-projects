# Project: Basic Web Scraping
## Instruction: get the data from the IMDb website and create a data frame with 3 columns including titles, ratings, and year.
## Website: https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc

# install the library using !pip
!pip install gazpacho

# import the functions Soup and requests
from gazpacho import Soup
import requests

# basic scrapping
url = "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc"

html = requests.get(url)
html.text

# assign the data into an object using Soup
imdb = Soup(html.text)
imdb

# get the specific data using the method .find()
## start with the title
titles = imdb.find("h3", {"class": "lister-item-header"})
titles # preview the data

## clean data by taking html arguments using the method .strip()
## also, I use the 'for' loop to clean the whole data.
titles[0].strip() # test 

## assign the clean data into a new list named 'clean_titles'
clean_titles = []

for title in titles:
    clean_titles.append(title.strip())

# double-check the result
clean_titles

# next, get the rating and clean data
ratings = imdb.find("div",{"class":"inline-block ratings-imdb-rating"})

## to check the result
ratings[5] 

## cleaning the rating data (same as cleaning the titles)
## also, I convert the clean_rating from string to float 

clean_ratings =[]

for rating in ratings:
    clean_ratings.append(float(rating.strip()))

## check the result
clean_ratings

## double-check the type of data
type(clean_ratings[0])

# lastly, get the year of the movie
years = imdb.find("span",{"class":"lister-item-year text-muted unbold"})

## pre-view
years[0]

## cleaning data by removing html arguments and parenthesis () 
import re

clean_years = []

for year in years:
    clean_year = year.strip() # to remove html arguments
    clean_year = re.sub('[()]','',clean_year) # to remove parenthesis
    clean_years.append(clean_year) # to add clean data into the new one I have created

# check the results
clean_years

# finally, create a data frame combining these 3 lists 
import pandas as pd

imdb_database = pd.DataFrame(data = {
    "title": clean_titles,
    "rating": clean_ratings,
    "year": clean_years
})

# pre-view the first 10 rows
imdb_database.head(10)
