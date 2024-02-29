def execute_function(file_name):
   with open(file_name, 'r') as file:
       exec(file.read())
def switch_case(choice):
   functions = ['Insert.py','Landing.py', 'Staging.py', 'Dimension.py', 'Fact.py']
   if choice in range(1, 7):
       if choice == 6:
           for func in functions:
               execute_function(func)
       else:
           execute_function(functions[choice - 1])
   else:
       print("Invalid choice")
while True:
   user_choice = int(input("Enter the function number to run (1-6):\n1.Insert Files \n2.Execute Landing Table \n3.Execute Staging Table \n4.Execute Dimension Table \n5.Execute Fact Table \n6.Execute All\n Option: "))
   switch_case(user_choice)
   continue_option = int(input("Press 1 to continue or 0 to exit: "))
   if continue_option != 1:
       print("Exiting...")
       break
