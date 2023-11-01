## Project: Pizza Order
## To create a chartbot for ordering a pizza and the result will show total price.
# Strat with creating vectors
pizza <- c("Pepperoni", "Margherita", "BBQ", "Carbonara", "Hawaiian")
size <- c("M", "L")
toppings <- c("Pepperoni", "Mozzarella", "Olives", "Mushroom", "Chicken")

menu <- list(
  pizza,
  size,
  toppings
)

# Then, I will create 2 functions for the pizza bases and the topping, and I will combine them together. 
# First, create a function for the pizza base and size
chatbot <- function(){
  menu
  index <- 1
  total_price_topping <- 0
  price_base <- 0
  price_topping <- 0
  
  print("Welcome, What Pizza would you like today? ")
  print("Menu: Pepperoni, Margherita, BBQ, Carbonara, and Hawaiian")
  user_customer <- readLines("stdin", n=1)
  
  if(user_customer %in% c("Pepperoni", "Margherita")){
    print("Size? M or L? ")
    size_input <- readLines("stdin", n=1)
    if(size_input == "M"){
      price_base <- 15
    } else if (size_input == "L"){
      price_base <- 20
    }
  } else if (user_customer %in% c("Carbonara", "Hawaiian")){
    print("Size? M or L? ")
    size_input <- readLines("stdin", n=1)
    if(size_input == "M"){
      price_base <- 17
    } else if (size_input == "L"){
      price_base <- 22
    }
  } else if (user_customer == "BBQ"){
    print("Size? M or L? ")
    size_input <- readLines("stdin", n=1)
    if(size_input == "M"){
      price_base <- 20
    } else if (size_input == "L"){
      price_base <- 25
    }
  }

  while (index <= length(toppings)) {
    print("Adding Toppings? ")
    print("Toppings: Pepperoni, Mozzarella, Olives, Mushroom, Chicken")
    user_customer <- readLines("stdin", n=1)
    
    if (user_customer == "no" || !(user_customer %in% toppings)){
      price_topping <- 0
      break
    } else {
      if (user_customer %in% c("Pepperoni", "Olives","Mozzarella")) {
        price_topping <- 2.5
      } else {
        price_topping <- 3
      } 
      
      total_price_topping <- total_price_topping + price_topping
    }
    
    index <- index + 1
  }
  
  return(total_price_topping + price_base)
  }

chatbot()
