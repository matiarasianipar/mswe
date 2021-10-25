# https://www.geeksforgeeks.org/selection-sort/
# # Read and tokenize input text file
import re
import sys
import time

start = time.time()

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


        for i in range(len(x)):

        # Find minimum element in remaining unsorted array
            minIndex = i
            for j in range(i+1, len(x)):
                if x[minIndex] > x[j]:
                    minIndex = j

            # Swap found min elem with 1st elem
            x[i], x[minIndex] = x[minIndex], x[i]

            
        for i in range(len(x)):
            print("%s" %x[i])
        
# If file is not present: return error
except FileNotFoundError:
    text = 'File not found'

end = time.time()

print(end - start)
