
""" Author: Karthik Kalyanum
    Date created: 23-Sep-2026
    Purpose: Student Grade Calculator
"""

marks = float(input("Enter your marks: "))

if marks >= 90:
    grade = "A"
elif marks >= 80:
    grade = "B"
elif marks >= 70:
    grade = "C"
elif marks >= 60:
    grade = "D"
else:
    grade = "F"

print("Your grade is:", grade)