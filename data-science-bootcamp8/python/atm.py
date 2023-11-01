# project: create an ATM with at least 5 methods
# in this project, I will apply the concept OOP (Object Oriented Programming).
## 2 attributes: account number and pin
## 5 methods: deposit, withdraw, pay, transfer, and PIN change

import getpass

class atm:
    def __init__(self, account_number, pin):
        self.account_number = account_number
        self.pin = pin

    def start(self):
        print("Welcome, what would you like to do today?")
        user = input(f"""Please choose the services below
                            Withdraw (1) 
                            Deposit (2)
                            Payment (3)
                            Transfer (4)
                            PIN Change (5)
                            : """) 
        if user == "1":
            self.withdraw()
        elif user == "2":
            self.deposit()
        elif user == "3":
            self.pay()
        elif user == "4":
            self.transfer()
        elif user == "5":
            self.pin_change()
        else:
            print("Invalid Answer. Please try again.")
            self.start()

    def ending(self):
        user_2 = input("Anything else you would like to do? Y/N: ")
        if user_2 == "Y":
            self.start()
        elif user_2 == "N":
            print("Thank you! Have A Nice Day!")
        else:
            print("Invalid Answer! Please try again.")
            self_ending()
    
    def withdraw(self):
        withdraw_amount = input("Enter the amount you would like to withdraw($): ")
        if int(withdraw_amount) < 20:
                print("The minimum amount is $20, please re-enter the amount.")
                self.withdraw()
        else:
            confirm_1 = input(f"Please confirm if the amount is correct? ${withdraw_amount} Y/N: ")
            if confirm_1 == "Y":
                print("Please collect your money.")
                self.ending()
            elif confirm_1 == "N":
                self.withdraw()
            else:
                print("Not Found! Please try again.")
                self.withdraw()

    def deposit(self):
        deposit_amount = input("Enter the amount you would like to deposit($): ")
        print("Please place the money in the space below.")
        confirm_2 = input(f"Please confirm if the amount is correct? ${deposit_amount} Y/N: ")

        if confirm_2 == "Y":
            print(f"You have successfully deposited ${deposit_amount}.")
            self.ending()
        else:
            print("Error! Please contact the bank.")

    def pay(self):
        print("Please enter the payment details.")
        invoice_number = input("Enter the invoice number (8-digit number): ")
        if len(invoice_number) == 8:
            pay_amount = input("Enter the amount($): ")
            print(f"""
                The invoice number: {invoice_number} 
                The amount: ${pay_amount}
                  """)
            confirm_3 = input("Please confirm if this is correct? Y/N: ")

            if confirm_3 == "Y":
                print("The payment is successful.")
                self.ending()
            else:
                self.pay()
        else: 
            print("The invoice number is invalid. Please re-enter.")
            self.pay()

    def transfer(self):
        print("Please enter the transfer details.")
        transfer_number = input("Enter the account number you would like to transfer: ")
        bank_code = input("Enter the bank code (4-digit number): ")
        transfer_amount = input("Enter the amount you would like to transfer ($): ")
        print(f"""
            Account Number: {transfer_number}
            Bank Code: {bank_code}
            Amount: ${transfer_amount}
            """)
        confirm_4 = input("Please confirm if this is correct? Y/N: ")
        if confirm_4 == "Y":
                print("The transfer is successful.")
                self.ending()
        else:
                self.transfer()

    def pin_change(self):
        old_pin = getpass.getpass("Enter your old pin: ")
        if old_pin == self.pin:
            new_pin = getpass.getpass("Enter the new PIN (4-digit number): ")
            if len(new_pin) != 4:
                print("Invalid PIN! Please re-enter.")
                self.pin_change()
            else:
                confirm_5 = getpass.getpass("Re-Enter the new PIN: ")
                if new_pin == confirm_5:
                    print("You have sucessfully changed the PIN.")
                    self.ending()
                else:
                    print("Invalid PIN! Please re-enter.")
                    self.pin_change()
        else:
            print("Invalid PIN! Please re-enter.")
            self.pin_change()

## example
account_number_1 = "40876"
pin_1 = "4568"
atm1 = atm(account_number_1, pin_1)

atm1.start()
