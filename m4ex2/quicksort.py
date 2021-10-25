import re
import sys
import time

start = time.time()

sys.setrecursionlimit(5000)

def quickSort(array, low, high):
    if ((high-low)> 0):
        p = partition(array, low, high)

        quickSort(array, low, p-1)
        quickSort(array, p+1, high)

def partition(array, low, high):

    p = high
    firstHigh = low
    i = low
    while(i < high):
        if array[i] < array[p]:
            array[i], array[firstHigh] = array[firstHigh], array[i]
            firstHigh += 1
        i += 1
    array[p], array[firstHigh] = array[firstHigh], array[p]

    return firstHigh

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
        n = n - 1
        quickSort(x, 0, n)
        for i in range(len(x)):
            print("%s" %x[i])

# If file is not present: return error
except FileNotFoundError:
    text = 'File not found'

end = time.time()
print(end-start)