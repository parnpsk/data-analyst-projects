## Project: Rock-Scissor-Paper Game
# create vectors, then, assign all choice to numbers
choices <- c("Rock", "Scissor", "Paper", "Quit")
choice_numbers <- c(Rock=1, Scissor=2, Paper=3, Quit=4)

# create the play_game function, including all vectors
play_game <- function(){
  
  choices <- c("Rock", "Scissor", "Paper", "Quit")
  choice_numbers <- c(Rock=1, Scissor=2, Paper=3, Quit=4)
  win <- 1
  lose <- 0
  tie <- 0
  total_point <- 0
  
  player_choice <- as.numeric(choice_numbers)  
  
  while (TRUE) {
    print("Choose: Rock[1], Scissor[2], Paper[3], Quit[4]?: ")
    player_choice <- readLines("stdin", n=1)
    if (player_choice == 4){
      print("Good Bye! Have A Nice Day!")
      break
    } else if (player_choice %in% c(1,2,3)){
      computer_choice <- sample(1:3, 1)
    }
    
        if (player_choice == computer_choice){
        point <- tie
        print("Tie: 0 point") 
      } else if ((player_choice == 1 & computer_choice == 2) || 
               (player_choice == 2 & computer_choice == 3) ||
               (player_choice == 3 & computer_choice == 1)){
        point <- win
        print("Win: 1 point")
      } else {
        point <- lose
        print("Loss: 0 point")
      }
    
    total_point <- total_point + point
    }
  cat("Total Scores:", total_point)
  }


play_game()
