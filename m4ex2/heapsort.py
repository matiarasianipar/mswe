# https://www.geeksforgeeks.org/python-program-for-heap-sort/
# Read and tokenize input text file
import re
import sys
import time

start = time.time()
# Heapify subtree rooted at index i
# n == size of heap
def heapify(arr, n, i):
    largest = i     # largest = root
    l = 2 * i + 1   # l = left
    r = 2 * i + 2   # r = right

    # If left child is not None and is greater than root
    if l < n and arr[i] < arr[l]:
        largest = l

    # If right child is not None and is greater than root
    if r < n and arr[largest] < arr[r]:
        largest = r

    # Change root
    if largest is not i:
        arr[i],arr[largest] = arr[largest],arr[i]

        # Heapify root
        heapify(arr, n, largest)

# Sort array
def heapSort(arr):
    n = len(arr)

    # Build maxheap
    for i in range(n // 2 - 1, -1, -1):
        heapify(arr, n, i)

    # Extract elems
    for i in range(n-1, 0, -1):
        arr[i], arr[0] = arr[0], arr[i]
        heapify(arr, i, 0)


try:
    with open('pride-and-prejudice-1.txt','r') as file1:
        # Read text file by line
        book = file1.readlines()

        # Initialize Linked Lists
        x = []

        # Remove punctuation & empty values
        for sentence in book:
            sentence = re.split("[^a-zA-Z0-9]+", sentence)
            for k in sentence:
                if k != (''):
                    x.append(k)
                    # print(k)
        # for each in x:
        #     print(each)
        heapSort(x)
        n = len(x)
        for i in range(n):
            print("%s" %x[i])


# If file is not present: return error
except FileNotFoundError:
    text = 'File not found'

end = time.time()
print(end-start)
