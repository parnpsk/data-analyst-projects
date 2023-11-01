# -- Project --
# Link: https://datalore.jetbrains.com/notebook/tQFSey9f5tC2ICcT7ZZJ1x/qs5Rvbx5DOrXlKMdFjq5v4

# # Final Project - Analyzing Sales Data
# 
# **Date**: 06 October 2023
# 
# **Author**: Parn Papitchayanan Santikul
# 
# **Course**: `Pandas Foundation`


# import data
import pandas as pd
df = pd.read_csv("sample-store.csv")

# preview top 5 rows
df.head(10)

# shape of dataframe
df.shape

# see data frame information using .info()
df.info()

## there are missing values in the Postal Code column

# We can use `pd.to_datetime()` function to convert columns 'Order Date' and 'Ship Date' to datetime.


# example of pd.to_datetime() function
pd.to_datetime(df['Order Date'].head(), format='%m/%d/%Y')

# TODO - convert order date and ship date to datetime in the original dataframe

df[['Order Date', 'Ship Date']] = df[['Order Date', 'Ship Date']].apply(pd.to_datetime, format = '%m/%d/%Y')

df.head() # to check the result

# TODO - count nan in postal code column
df['Postal Code'].isna().sum()

## there are 11 nan in postal code column

# TODO - filter rows with missing values
## as I have already known that all missing value is in the Postal Code column, so I filter only this column.
df[df['Postal Code'].isna()]

## all missing values are from the state "Vermont" 
df[df['State'] == "Vermont"]
df[df['City'] == "Burlington"]

# TODO - Explore this dataset on your owns, ask your own questions
## check the data range in the data
print(df['Order Date'].min(), df['Order Date'].max())

## the data starts from 2017-01-03 until 2020-12-30 

## find out the average delivery time of each ship mode.
from datetime import datetime

## create a new column with the date difference between Order Date and Ship Date
df['Delivery Day'] = df['Ship Date'] - df['Order Date']
df # preview the result

## group the data by Ship Mode to see the average delivery day or each mode
df.groupby('Ship Mode')['Delivery Day'].mean().sort_values()

### the average delivery day of each mode: 2 days for First Class, 3 days for Second Class, and 5 days for Standard. 

## basic statistic
df[['Sales','Quantity','Discount','Profit']].describe().round(2)

# ## Data Analysis Part
# 
# Answer 10 below questions to get credit from this course. Write `pandas` code to find answers.


# TODO 01 - how many columns, rows in this dataset
df.shape

## there are 9994 rows and 21 columns in this dataset.

# TODO 02 - is there any missing values?, if there is, which colunm? how many nan values?
df.info() ## there are missing values in the column Postal Code

df['Postal Code'].isna().sum() ## there are 11 missing values

# TODO 03 - your friend ask for `California` data, filter it and export csv for him
df[df['State'] == "California"].to_csv("CaliforniaData.csv")

# TODO 04 - your friend ask for all order data in `California` and `Texas` in 2017 (look at Order Date), send him csv file
df[(df['State'].isin(["California", "Texas"])) & (df['Order Date'].dt.strftime('%Y') == "2017")].to_csv("CalTex2017.csv")

# TODO 05 - how much total sales, average sales, and standard deviation of sales your company make in 2017
## create a data frame for 2017
df_2017 = df[df['Order Date'].dt.strftime('%Y') == "2017"]

df_2017['Sales'].agg(['sum', 'mean','std']).round(2)
## total sales = $484,247.50, average sales = $242.97, and standard deviation = 754.05

# TODO 06 - which Segment has the highest profit in 2018
## create a data frame for 2018
df_2018 = df[df['Order Date'].dt.strftime('%Y') == "2018"]

## group the data frame by Segment 
df_2018.groupby('Segment')['Profit'].sum().sort_values(ascending = False).head(1)

## Consumer has the highest profit in 2018

# TODO 07 - which top 5 States have the least total sales between 15 April 2019 - 31 December 2019
df[(df['Order Date'] >= "2019-04-15") & (df['Order Date'] <= "2019-12-31")].groupby('State')['Sales'].sum().sort_values().head()

# TODO 08 - what is the proportion of total sales (%) in West + Central in 2019 e.g. 25% 
## create a data frame for 2019
df_2019 = df[df['Order Date'].dt.strftime('%Y') == "2019"]

## total sales in 2019
sales_2019 = df_2019['Sales'].sum()

## filter the data in West & Central in 2019
filtered_df_2019 = df_2019[df_2019['Region'].isin(["West","Central"])]

## total sales in West & Central in 2019
west_cent_sales_2019 = filtered_df_2019['Sales'].sum()

## calculate the propottion 
print(round((west_cent_sales_2019/sales_2019)*100, 2))

## the proportion of total sales in West and Central in 2019 is about 55%. 

# TODO 09 - find top 10 popular products in terms of number of orders vs. total sales during 2019-2020
## create a data frame for 2019 and 2020
df_2019_2020 = df[df['Order Date'].dt.strftime('%Y').isin(["2019","2020"])]

## in terms od number of orders
df_2019_2020.groupby('Product Name')['Order ID'].count().sort_values(ascending = False).head(10)

## in terms of total sales
df_2019_2020.groupby('Product Name')['Sales'].sum().sort_values(ascending = False).head(10)

## in terms of quantities
df_2019_2020.groupby('Product Name')['Quantity'].sum().sort_values(ascending = False).head(10)

# TODO 10 - plot at least 2 plots, any plot you think interesting :)
from matplotlib import pyplot as plt

## group the data by year to see total sales and profit of each year
df_year = df.groupby(df['Order Date'].dt.year)[['Sales', 'Profit']].sum()

## create a bar chart for sales & profit by year
df_year.plot(kind='bar', color = ['#808000','#FFA500'])
plt.title('Sales & Profit by Year')
plt.xlabel('Year')
plt.ylabel('USD $')
plt.show()

## sales slightly dropped in 2018, however, profit increase every year between 2017 and 2020. 

## I will focus on the sales in 2019
## the top 10 Sub-Categories that have the highest sales in 2019
df_2019.groupby('Sub-Category')['Sales'].sum().sort_values(ascending=False).head(10).plot(kind='bar',color='#3B9C9C')
plt.title('Top 10 Sub-Categories with Highest Sales in 2019')
plt.ylabel('USD $')
plt.xlabel('')
plt.show()

## the top 5 Sub-Categories that have the lowest sales in 2019
df_2019.groupby('Sub-Category')['Profit'].sum().sort_values(ascending=False).head(10).plot(kind='bar',color='#43BFC7')
plt.title('Top 10 Sub-Categories with Hightest Profit in 2019')
plt.ylabel('USD $')
plt.xlabel('')
plt.show()

## although chairs has the highest sales in 2019, copies makes the highest profit to the company. 

## create a pie chart for sales of each region in 2019
df_2019.groupby('Region')['Sales'].sum()\
    .plot(kind='pie',\
          title = 'Sales in 2019 By Region',\
          legend = False,\
          autopct='%1.2f%%',\
          colormap='viridis')
plt.ylabel('')
plt.show()

## In 2019, we sold the most in West and the least in South. Hence, it is recommended to focus on expanding the market in the South to increase sales in the future. 

# TODO Bonus - use np.where() to create new column in dataframe to help you answer your own questions
import numpy as np

## statas that have profit < 0 in 2019
### calculate the profit for each state
profit_per_state = df_2019.groupby('State')['Profit'].sum().round(2)
type(profit_per_state)

## convert the data type of profit_per_state to data frame
profit_per_state = profit_per_state.to_frame()
type(profit_per_state)

### create a new column to clarify which states are loss-making ot profitable 
profit_per_state['Profitability'] = np.where(profit_per_state<0,'Loss-making','Profitable')
profit_per_state[profit_per_state['Profitability'] == "Loss-making"].sort_values(by='Profit')

### there are 9 unprofitable states in 2019.  
