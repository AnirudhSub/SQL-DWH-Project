def function1():
    with open('Landing.py','r') as file:
        exec (file.read())

def function2():
    with open('Staging.py','r') as file:
        exec (file.read())

def function3():
    with open('Dimension.py','r') as file:
        exec (file.read())

def function4():
    with open('Fact.py','r') as file:
        exec (file.read())

def function5():
    with open('Landing.py','r') as file:
        exec (file.read())
    with open('Staging.py','r') as file:
        exec (file.read())
    with open('Dimension.py','r') as file:
        exec (file.read())
    with open('Fact.py','r') as file:
        exec (file.read())

def switch_case(choice):
    if choice == 1:
        function1()
    elif choice == 2:
        function2()
    elif choice == 3:
        function3()
    elif choice == 4:
        function4()
    elif choice ==5:
        function5()
    else:
        print("Invalid choice")
user_choice = int(input("Enter the function number to run (1-5): "))
switch_case(user_choice)