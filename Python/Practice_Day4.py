"""
if <conditon>:
    do something here
    do something here
    do something here
    do something here
    do something here

print("")
"""
'''
for car in ["benz", "audi", "tata nano", "jaguar", "mg hector"]:
    print(car)
'''
    
"""
cars = ["benz", "audi", "tata nano", "jaguar", "mg hector"]
print("START OF FOR LOOP...")
for car in cars:
    if car == "jaguar":
        print(car.title())
    else:
        print("Car is not Jagaur")
print("END OF FOR LOOP...")
"""

"""
Modify above program to print output in the below format:
Benz
Audi
Tata Nano
JAGUAR
MG HECTOR
"""

# PRINT USING FOR LOOP NUMBERS FROM 1 to 10 USING LISTS:
"""
car = "MG HECTOR"
print("OUTSIDE IF-ELSE BLOCK: ", car)

if car == "JAGUAR":
    print("INSIDE IF BLOCK: ", car)
else:
    print("INSIDE ELSE BLOCK: ", car)

print("OUTSIDE OF IF-ELSE BLOCK")
"""

"""
if <CONDITION>:
    do something here
else:
    do something here
"""
"""
COMPARISON OPERATORS:
=
==

<
<=
>
>=

AND --> higher precedence
OR  ==> lower precedence

"""

"""	AND				                OR	
X	    Y	    RESULT		X	    Y	    RESULT
TRUE	TRUE	TRUE		TRUE	TRUE	TRUE
TRUE	FALSE	FALSE		TRUE	FALSE	TRUE
FALSE	TRUE	FALSE		FALSE	TRUE	TRUE
FALSE	FALSE	FALSE		FALSE	FALSE	FALSE
  """
"""
num1 = 100
if num1 >= 100 or num1 < 200 and num1 < 100 and num1 > 5000:
    print(True)
else:
    print(False)




1. Conditional Tests: 
Write a series of conditional tests. Print a statement
    describing each test and your prediction for the results of each test. Your code
    should look something like this:
car = 'subaru'
print("Is car == 'subaru'? I predict True.")
print(car == 'subaru')
print("\nIs car == 'audi'? I predict False.")
print(car == 'audi')
• Look closely at your results, and make sure you understand why each line
  evaluates to True or False.
• Create at least ten tests. Have at least five tests evaluated to True and
another five tests evaluate to False.

2. More Conditional Tests: You don’t have to limit the number of tests you
     create to ten. If you want to try more comparisons, write more tests and add
     them to conditional_tests.py. Have at least one True and one False result for
     each of the following:
• Tests for equality and inequality with strings
• Tests using the lower() method
• Numerical tests involving equality and inequality, greater than and
   less than, greater than or equal to, and less than or equal to
• Tests using the and keyword and the or keyword
• Test whether an item is in a list
• Test whether an item is not in a list


IF-ELIF-ELSE statement

Consider an amusement park that charges different rates for different age groups:
• Admission for anyone under age 4 is free.
• Admission for anyone between the ages of 4 and 18 is $25.
• Admission for anyone of age between 19 and 64 is $40.
  Anyone 65 or older pays half the regular admission, or $20

0, 1, 2, 3 ===> $0
4, 5, 6, 7,..... 18 ===> $ 25
19, 20, 21, ....    ===> $ 40
""" 

"""
age = 90
if age < 4:
    print("Admission is FREE!!! and admission fee is $0")
# elif age >=4 and age <=18:
elif age <= 18:
    print("Admission fee is $25")
else:
    print("Admission fee is $40")

print("OUTSIDE OF IF-ELIF-ELSE BLOCK...")
"""

# IF-ELIF-ELIF-ELSE  -- Multiple ElIFs
"""
age = 90
if age < 4:
    print("Admission is FREE!!! and admission fee is $0")
# elif age >=4 and age <=18:
elif age <= 18:
    print("Admission fee is $25")
elif age < 65:
    print("Admission fee is $40")
else:
    print("Admission fee is $20")
    print("I AM A HACKER!!!")

print("OUTSIDE OF IF-ELIF-ELSE BLOCK...")
"""

age = 25
if age < 4:
    print("Admission is FREE!!! and admission fee is $0")
# elif age >=4 and age <=18:
elif age <= 18:
    print("Admission fee is $25")
elif age < 65:
    print("Admission fee is $40")
elif age >= 65:
    print("Admission fee is $20")

print("OUTSIDE OF IF-ELIF-ELSE BLOCK...")