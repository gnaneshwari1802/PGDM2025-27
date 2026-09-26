"""
for cars in ['audi', 'bmw', 'mg hector', 'benz']:
	if cars == 'bmw':
		print(cars.upper())
	else:
		print(cars.title())
"""

"""
car = 'BMW'
if car != 'Audi':
    print("The said car is NOT Audi")
"""

cars = ['audi', 'bmw', 'mg hector', 'benz']
new_car = 'jaguar'
if new_car not in cars:
        print(f'{new_car} is not present in the cars list')
        
