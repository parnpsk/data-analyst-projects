# Project Name: House Price In India
# Date: 22/08/2023
# Subject: Machine Learning in R
# Task: Create a regression model to predict the houses' price in India

--------------------------------------------------------------------------
## There are 5 steps to create a simple ML pipeline
# 1. prepare data / prep data
# 2. split data
# 3. train model
# 4. score model aka. prediction
# 5. evaluate model  
  
---------------------------------------------------------------------------
# first case: I will only focus on the 2016 data 
# 1. preparation
# prepare the environment
install.packages("tidyverse")
install.packages("caret")
install.packages("readxl")

library(tidyverse)
library(caret)
library(readxl)

# import the data set
house_price_2016 <- read_excel("C:/Users/papit/OneDrive/Desktop/2023/Learning/Bootcamp/Machine Learning/House Price India.xlsx", 
                                sheet = "House 2016")

# preview the data
head(house_price_2016)
colnames(house_price_2016)

# check the price column
hist(house_price_2016$Price)

# The histogram shows that the price column is right-skewed distribution, so we have to adjust the distribution 
# by using the function log() to make it more like a normal distribution.
hist(log(house_price_2016$Price)) # preview the function

house_price_2016$Price <- log(house_price_2016$Price)

# I pick 5 variables to use in a model: "number of bedrooms", "condition of the house", "Area of the house(excluding basement)",
# "Built Year", and "number of bathrooms"
df_2016 <- house_price_2016 %>%
  select(n_bed = `number of bedrooms`, 
         n_bath = `number of bathrooms`,
         n_floor = `number of floors`,
         n_view = `number of views`,
         grade = `grade of the house`,
         cond = `condition of the house`,
         area = `Area of the house(excluding basement)`, 
         year = `Built Year`,
         dist_airport = `Distance from the airport`,
         price = Price)

# check for missing values
df_2016 %>% complete.cases() %>%
  mean() # no na

# 2. split the data into 2 groups: 80% train and 20% test
# first, I create a function for spliting data
split_data <- function(df) {
  set.seed(13)
n <- nrow(df)
train_id <- sample(1:n, size = 0.8*n)
train_df <- df[train_id, ]
test_df <- df[-train_id, ]
list(training = train_df,
     testing = test_df)
}

# test the function with the data set 2016
prep_data <- split_data(df_2016)

# separate the data into 2 groups 
train_df <- prep_data[[1]]
test_df <- prep_data[[2]]

# 3. train model by using the function train()
set.seed(13)
lm_model <- train(price ~ .,
                  data = train_df,
                  method = "lm")

lm_model

# 4. score the model by using the predict() function
p <- predict(lm_model, newdata = test_df)

# 5. evaluate the model by comparing the actual data in test_df with the predicted data 
# first, calculate mean absolute error
(mae <- mean(abs(p - test_df$price)))

# second, calculate root mean square error
(rmse <- sqrt(mean((p - test_df$price)**2)))

------------------------------------------------------------------------------
# second case: I will use the 2016 data 2016 as train data and the 2017 data as test data/
# 1. prepare data
# import the 2017 data
house_price_2017 <- read_excel("C:/Users/papit/OneDrive/Desktop/2023/Learning/Bootcamp/Machine Learning/House Price India.xlsx", 
                                 sheet = "House 2017")

# preview the 2017 data set
head(house_price_2017)
hist(house_price_2017$Price)

house_price_2017$Price <- log(house_price_2017$Price)

# create df_2017 with the same columns as the df_2016
df_2017 <- house_price_2017 %>%
  select(n_bed = `number of bedrooms`, 
         n_bath = `number of bathrooms`,
         n_floor = `number of floors`,
         n_view = `number of views`,
         grade = `grade of the house`,
         cond = `condition of the house`,
         area = `Area of the house(excluding basement)`, 
         year = `Built Year`,
         dist_airport = `Distance from the airport`,
         price = Price)

# check for na
df_2017 %>% complete.cases() %>%
  mean() # no na

# I do not need to do the split process as we have already got 2 separated data sets for train and test.
# 2. train model by using the function train()
set.seed(20)
lm_model2 <- train(price ~ .,
                   data = df_2016,
                   method = "lm")

lm_model2

# 3. score the model by using the predict() function
p2 <- predict(lm_model2, newdata = df_2017)

# 4. evaluate the model by comparing the actual data in test_df with the predicted data 
(mae2 <- mean(abs(p2 - df_2017$price))) 

(rmse2 <- sqrt(mean((p2 - df_2017$price)**2))) 

## mae2 = 0.3253825 VS mae(lm_model2) = 0.2995062
## rmse2 = 0.4044956 VS rmse(lm_model2) = 0.3759509
