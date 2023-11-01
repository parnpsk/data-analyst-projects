# Project: Public API
## In this project, I will get the data from a public API into Python.
## API source: https://publicapis.io/punk-api

## import the function requests
import requests

## get the data 
url = "https://api.punkapi.com/v2/beers/"

resp = requests.get(url)
resp.status_code # if the result is 200. it means the process is done sucessfully.

# to pre-view the data
resp.text
resp.json()
type(resp.json()) # to check the type (optional)

--------------------------------------------------------------------------------------------
# put everything together and write for loop to create a list of the data.
import requests

beers = []

url = "https://api.punkapi.com/v2/beers/"
resp = requests.get(url)
data_list = resp.json()

for data in data_list:
        beers.append(
            (data.get("name"),
             data.get("first_brewed"),
             data.get("description"),
             data.get("food_pairing"))
        )

print(beers)
