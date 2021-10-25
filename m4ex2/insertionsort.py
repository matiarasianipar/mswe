# https://www.geeksforgeeks.org/python-program-for-insertion-sort/
# Read and tokenize input text file
import re
import sys
import time

start = time.time()

def insertionSort(arr):
    
    # Traverse 1 to len(arr):
    for i in range(1, len(arr)):

        key = arr[i]

        j = i - 1
        while j >= 0 and key < arr[j]:
            arr[j+1] = arr[j]
            j = j - 1
        arr[j+1] = key

try:
    with open('pride-and-prejudice-1.txt','r') as file1:
        # Read text file by line
        book = file1.readlines()

        # Initialize Linked Lists
        x = []
        y = ['hello', 'elena', 'world', 'mswe']

        # Remove punctuation & empty values
        for sentence in book:
            sentence = re.split("[^a-zA-Z0-9]+", sentence)
            for k in sentence:
                if k != (''):
                    x.append(k)
                    # print(k)
        # for each in x:
        #     print(each)
        insertionSort(x)

        for i in range(len(x)):
            print("%s" %x[i])

        # insertionSort(y)

        # for i in range(len(y)):
        #     print("%s" %y[i])

# If file is not present: return error
except FileNotFoundError:
    text = 'File not found'

end = time.time()
print(end-start)
