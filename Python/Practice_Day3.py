"""
a = 'abc'
b = 'def'
print(a, ' ', b)
"""

"""
cars = ['audi', 'bmw', 'benz', 'mg hector']
print(cars)
print(cars[0]) 

print(cars[-1])
print(cars[-2])
"""

"""
names = []
print(names)
print(names[-1])
print(names[0])
"""

"""
names = ['shruthi', 'rahul', 'madhu']
print(f"Hi! {names[0].title()}, How are you?")
print(f"Hi! {names[1].title()}, How are you?")
print(f"Hi! {names[2].title()}, How are you?")

print(f"Hi! {names[0]}, How are you?")

print("Hi!", names[0], "How are you?")
"""

"""
names = ['shruthi', 'rahul', 'madhu']
names[2] = 'Karthik'
# print(names)

names.append('Ramesh')
# print(names)
names.insert(1, "Mahesh")
# print(names)

del names[1]
# print(names)

var1 = names.pop(2)
print(names)
print(var1)

names.remove('rahul')
print(names)
"""

"""
names.append('rahul')
print(names)
names.remove('Rahul')
print(names)
"""

"""
names.append("Karthik")
names.append("shruthi")
# print(names)

names.sort()
# print(names)

names.sort(reverse = True)
# print(names)

"""
"""
print("Before sort(): ", names)
names.sort()
print("After sort(): ", names)
"""
"""
print("Before sorted(): ", names)
var1 = sorted(names)
print("After sorted() inside the variable", var1)
print("After sorted(): ", names)

cars = ['bmw', 'mg hector', 'benz', 'audi']
var2 = sorted(cars, reverse = False)
print(var2)
print(cars)
"""

cars = ['bmw', 'mg hector', 'benz', 'audi']
print("Before revers(): ", cars)
cars.reverse()
print("After reverse(): ", cars)

length_of_list = len(cars)
print("Length = ", length_of_list)