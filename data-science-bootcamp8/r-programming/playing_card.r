## Project: Playing Card
## create a deck of cards
## source: https://rstudio-education.github.io/hopr/modify.html

## create a vector named head for the face name of cards
head <- c("ace", "king", "queen", "jack", "ten")

## create a matrix for every card in a royal flush
head1 <- c("ace", "king", "queen", "jack", "ten", "spades", "spades", "spades", "spades", "spades")

matrix <- matrix(head1, 5)

## same results as the above
matrix(head1, nrow = 5)
matrix(hand1, ncol = 2)
dim(hand1) <- c(5, 2)

## to build an entire deck of cards by creating a data frame (52 cards)
df <- data.frame(face = c("king", "queen", "jack", "ten", "nine", "eight", "seven", "six",
                          "five", "four", "three", "two", "ace", "king", "queen", "jack", "ten", 
                          "nine", "eight", "seven", "six", "five", "four", "three", "two", "ace", 
                          "king", "queen", "jack", "ten", "nine", "eight", "seven", "six", "five", 
                          "four", "three", "two", "ace", "king", "queen", "jack", "ten", "nine", 
                          "eight", "seven", "six", "five", "four", "three", "two", "ace"),
                 suit = c("spades", "spades", "spades", "spades", "spades", "spades", 
                          "spades", "spades", "spades", "spades", "spades", "spades", "spades", 
                          "clubs", "clubs", "clubs", "clubs", "clubs", "clubs", "clubs", "clubs", 
                          "clubs", "clubs", "clubs", "clubs", "clubs", "diamonds", "diamonds", 
                          "diamonds", "diamonds", "diamonds", "diamonds", "diamonds", "diamonds", 
                          "diamonds", "diamonds", "diamonds", "diamonds", "diamonds", "hearts", 
                          "hearts", "hearts", "hearts", "hearts", "hearts", "hearts", "hearts", 
                          "hearts", "hearts", "hearts", "hearts", "hearts"),
                 value = c(13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 13, 12, 11, 10, 9, 8, 
                           7, 6, 5, 4, 3, 2, 1, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 13, 12, 11, 
                           10, 9, 8, 7, 6, 5, 4, 3, 2, 1))

# avoid typing large data sets by importing a text file, R will assign it as a data frame.
# import the csv named deck
head(deck)

# to save a data set
write.csv(deck, file = "cards.csv", row.names = FALSE)

# to create a function that returns the first row of a data frame
deal <- function(cards){
  cards[1, ]
}

# the function will be useless when running the function over and over as the results will be the same. 
deal(deck)

# the problem will be fixed by shuffling the deck after every deal. Then, the new card will always on the top. 
# to shuffle the deck, you need to randomly reorder the rows in the data frame.
# If you want the rows to come in a random order, then you need to sort the integers from 1 to 52 into a random order and use the results as a row index by using the sample function.
random <- sample(1:52, size = 52)

# create a function to return a shuffled copy of the data frame cards
shuffle <- function(cards){
  random <- sample(1:52, size = 52)
  cards[random, ]
}

# run these 2 together
deck2 <- shuffle(deck)
deal(deck2)

# modifying the data
# task: to change the point system of the deck three times to match three different games: war, hearts, and blackjack.
# make a copy of the data frame before start manipulating it
deck2 <- deck

# add a new variable into the data frame
deck2$new <- 1:52

head(deck2)

# to remove columns from a data frame by assigning the symbol NULL
deck2$new <- NULL

# in the game of war, aces are king and they receive the highest value
# we need to change the value of ace to be from 1 to 14. 
# first, we extract all ace in the deck data frame by their locations : 13, 26, 39, 52
# the cards were sorted in an orderly manner and an ace appeared every 13 rows.
deck2[c(13,26,39,52), ]

# then, modify the value column to 14
deck2$value[c(13,26,39,52)] <- c(14,14,14,14)

deck2


# create a new data frame for shuffled cards
deck3 <- shuffle(deck)

# first, create a logical subset to identify the aces in the shuffled deck
deck3$face == "ace"

# then, use it as an index to single out the ace point values
deck3$value[deck3$face == "ace"]

# assign the value (14) into a shuffled deck
deck3$value[deck3$face == "ace"] <- 14


# create a new data frame for the hearts game
deck4 <- deck

# modify the values of all to be 0 as in hearts, every card has a value of zero.
deck4$value <- 0

# each card in the suit of hearts has a value of 1.
deck4$value[deck4$suit == "hearts"] <- 1

# in hearts, the queen of spades has the most unusual value of all: she’s worth 13 points.
# we cannot use logical subsetting as there are too many. We will use Boolean Operators.
deck4[deck4$face == "queen", ]

# use boolean operators to identify the queen of spades.
deck4$face == "queen" & deck4$suit == "spades"

# save the result into a variable to make it easier to use
queenOfSpades <- deck4$face == "queen" & deck4$suit == "spades"

# use a new variable as an index to modify the value to 13
deck4[queenOfSpades, ] 

deck4$value[queenOfSpades] <- 13

# in blackjack
# create a new data frame for the game
deck5 <- deck

# pre-view the first 10 rows
head(deck5, 10)

# first, creat a new variable for all face card
faceCard <- deck5$face %in% c("king", "queen", "jack")

# then, modify the value to 10
deck5$value[faceCard] <- 10

# it is hard to decide what value to give the aces because their exact value will change from hand to hand.
# assign the value of ace to NA for 2 reasons
# first, it remind that we do not know the value of the ace
# second, it will prevent you from accidentally scoring the ace before determining the final value of it.
deck5$value[deck5$face == "ace"] <- NA
