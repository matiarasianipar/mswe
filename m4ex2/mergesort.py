# https://www.geeksforgeeks.org/merge-sort/
import re

def mergeSort(arr):
    if len(arr) > 1:

        # find middle of array
        mid = len(arr)//2

        # divide array elements
        # left half
        L = arr[:mid]

        # right half
        R = arr[mid:]

        # sort first half
        mergeSort(L)

        mergeSort(R)

        i = 0
        j = 0
        k = 0

        # copy data to temp arrays
        while i < len(L) and j < len(R):
            if L[i] < R[j]:
                arr[k] = L[i]
                i += 1
            else:
                arr[k] = R[j]
                j += 1
            k += 1

        # check for leftover elements
        while i < len(L):
            arr[k] = L[i]
            i += 1
            k += 1

        while j < len(R):
            arr[k] = R[j]
            j += 1
            k += 1

try:
    with open('pride-and-prejudice-1.txt','r') as file1:
        # Read text file by line
        book = file1.readlines()

        # Initialize Linked Lists
        x = []
        y = [12, 11, 13, 5, 6, 7]

        # Remove punctuation & empty values
        for sentence in book:
            sentence = re.split("[^a-zA-Z0-9]+", sentence)
            for k in sentence:
                if k != (''):
                    x.append(k)
                    # print(k)
        # for each in x:
        #     print(each)
        n = len(x)
        mergeSort(x)
        for i in range(n):
            print("%s" %x[i])

# If file is not present: return error
except FileNotFoundError:
    text = 'File not found'