## project: Rolling Dice
## to create a weighted dice
## source: https://rstudio-education.github.io/hopr/project-1-weighted-dice.html

## create an object represented a dice, a pair of dices, and the total of a pair of dices. 
die <- 1:6
dice <- sample(die, 2, replace = TRUE)
sum(dice)


## create a new function to roll the dice named roll()
roll <- function() {
  die <- 1:6
  dice <- sample(die, 2, replace = TRUE)
  sum(dice)
}

## check the new function
roll()

## to check what codes are inside the function (the body of the function), write the function's name without parenthesis.
roll

## if you want to make an argument of the function, add the name of an argument within ()
# create 'bones' as an argument in the roll2 function
roll2 <- function(bones) {
  die <- 1:6
  dice <- sample(bones, 2, replace = TRUE)
  sum(dice)
}

roll2(bones = 1:10)
roll2(1:6)

## if you do not supply 'bones' argument, it shows error.
roll2()

## However, you can set a default argument when creating a function
roll2 <- function(bones = 1:6) {
  dice <- sample(bones, 2, replace = TRUE)
  sum(dice)
}

roll2()

## prepare the environment by installing packages
install.packages("ggplot2")

## to open the package
library("ggplot2")

## check the accuracy of the dice by using a histogram to make sure the dices are fairly weighted.
# first, use replicate to roll the dice multiple times before plotting them in a histogram
rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)

## change the probabilities by add a new argument to the sample function.
roll <- function() {
  die <- 1:6
  dice <- sample(die, 2, replace = TRUE, prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8))
  sum(dice)
}

# rerun the code
rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)
