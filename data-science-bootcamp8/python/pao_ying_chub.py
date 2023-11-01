# Project: Create a Rock-Scissors-Paper game

## prepare the environment: import the package 'random'  
import random

## create a function asking for input from a user
### I use while loop and if-else to set conditions for the game
def start_gaming():
    options_list = ["rock", "paper", "scissors"] #create a list of choices for the game
    option = random.choice(options_list) # pick a random element from the list using the function random.choice()
    your_answers = [] # to keep all answers during the game
    while True:
        answer = input("rock? paper? scissors? or quite?: ")
        your_answers.append(answer)
        if ((answer == "rock") and (random.choice(options_list) == "scissors")) or\
            ((answer == "paper") and (random.choice(options_list) == "rock")) or\
            ((answer == "scissors") and (random.choice(options_list) == "paper")):
            print("You Win! Play Again?")
        elif answer == random.choice(options_list):
            print("Draw! Try Again?")
        elif answer == "quite":
            print("Bye Now!")
            break
        elif answer not in options_list:
            print("Please Check Your Spelling! Try Again?")
        else:
            print("You Lose! Try Again?") 

start_gaming()
