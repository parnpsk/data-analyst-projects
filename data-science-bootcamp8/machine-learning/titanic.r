## Project: Titanic
## Create a model to predict survival
## prepare the environment
install.packages("caret")
library(caret)

library(titanic)
head(titanic_train)

# drop missing values
titanic_train <- na.omit(titanic_train) 
nrow(titanic_train)

## Sex > change to factor before adding the variable into the model
titanic_train$Sex <- factor(titanic_train$Sex,
                            levels = c("male", "female"),
                            labels = c(0, 1))

# split data train:test = 70:30
set.seed(42)
n <- nrow(titanic_train)
id <- sample(1:n, size = n*0.7)
train_data <- titanic_train[id, ]
test_data <- titanic_train[-id, ]

## create a function for split data
split_data <- function(df){
  set.seed(42)
  n <- nrow(df)
  id <- sample(1:n, size = n*0.7)
  train_data <- titanic_train[id, ]
  test_data <- titanic_train[-id, ]
}

titanic_data <- split_data(titanic_train)

# split data into 2 groups
train_data <- titanic_data[[1]]
test_data <- titanic_data[[2]]

# check the number of rows
nrow(train_data)
nrow(test_data)

# train model
glm_model <- glm(Survived ~ Pclass + Age + Sex, 
                 data = train_data, 
                 family = "binomial")

summary(glm_model)

# predict and evaluate model
train_data$prob_survived <- predict(glm_model, 
                                    type = "response")
train_data$pred_survived <- ifelse(train_data$prob_survived >= 0.5, 1, 0)

## do the same with test_data
test_data$prob_survived <- predict(glm_model, 
                                   newdata = test_data,
                                   type = "response")
test_data$pred_survived <- ifelse(test_data$prob_survived >= 0.5, 1, 0)

# create confusion matrix
## Train Model Evaluation
train_conM <- table(train_data$pred_survived, train_data$Survived,
      dnn = c("Predicted", "Actual"))

train_conM

## calculate the accuracy of the train model
train_acc <- (train_conM[1, 1] + train_conM[2,2])/sum(train_conM)
train_pre <- train_conM[2,2]/(train_conM[2,1]+train_conM[2,2])
train_rec <- train_conM[2,2]/(train_conM[1,2]+train_conM[2,2])
train_f1 <- 2*((train_pre*train_rec)/(train_pre+train_rec))

cat("Train Model Evaluation",
    "\nAccuracy: ",train_acc,
    "\nPrecision: ", train_pre,
    "\nRecall: ", train_rec
    )

## Test Model Evaluation
test_conM <- table(test_data$pred_survived, test_data$Survived,
                   dnn = c("Predicted", "Actual"))

test_conM

## calculate the accuracy of the test model
test_acc <- (test_conM[1,1]+test_conM[2,2])/sum(test_conM)
test_pre <- test_conM[2,2]/(test_conM[2,1]+ test_conM[2,2])
test_rec <- test_conM[2,2]/(test_conM[1,2]+test_conM[2,2])
test_f1 <- 2*((test_pre*test_rec)/(test_pre+test_rec))

cat("Test Model Evaluation",
    "\nAccuracy: ",test_acc,
    "\nPrecision: ", test_pre,
    "\nRecall: ", test_rec
)

### compare the confusion matrices of train and test models
# Summary 
# The test model has higher values of Accuracy, Precision, and REcall. 
