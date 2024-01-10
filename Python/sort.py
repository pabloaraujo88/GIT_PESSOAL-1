import random

# Function to generate 6 unique random numbers between 1 and 50
def generate_lottery_numbers():
    lottery_numbers = set()  # Use a set to ensure uniqueness
    while len(lottery_numbers) < 50:
        number = random.randint(1, 100)
        lottery_numbers.add(number)
    return list(lottery_numbers)

# Generate and sort the lottery numbers
if __name__ == "__main__":
    lottery_numbers = generate_lottery_numbers()
    sorted_numbers = sorted(lottery_numbers)
    
    print("Lottery Numbers (sorted):", sorted_numbers)
