# Code uses the following sources:
# Almost prints without duplicates (some values are missing i think)
# https://www.geeksforgeeks.org/reading-writing-text-files-python/
# https://leetcode.com/discuss/general-discussion/603729/singly-linked-list-data-structure-python
# https://stackoverflow.com/questions/46249213/how-to-check-if-item-is-in-a-linked-list
# I'm prepared to explain and demonstrate my full understanding of this code
import re
import math

# https://www.youtube.com/watch?v=JlMyYuY1aXU
# Initialize Node
class Node:

    def __init__(self, data):
        self.data = data
        self.next = None

# Initialize LinkedList
class LinkedList:

    def __init__(self):
        self.head = None
        self.newNode = None

    def contains(self, item):
        if(self.head == None):
            return False
        else:
            pointer = self.head
            while pointer is not None:
                if pointer.data == item:
                    return True
                pointer = pointer.next
            return False

    def add(self, item):
        if self.contains(item) == False:
            if(self.head == None):
                self.head = Node(item)
                self.newNode = self.head
                return True
            else:
                while(self.newNode.next != None):
                    self.newNode = self.newNode.next
                self.newNode.next = Node(item)
                self.newNode = self.newNode.next
                return False
        else:
            return False

    def size(self):
        count = 0
        temp = self.head
        while (temp!= None):
            # print(self.head.data)
            temp = temp.next
            count += 1
        print('Size of book: ', count)

try:
    with open('pride-and-prejudice.txt','r') as file1:
        # Read text file by line
        book = file1.readlines()

        # Initialize Linked Lists
        x = LinkedList()

        # Remove punctuation & empty values
        for sentence in book:
            sentence = re.split("[^a-zA-Z0-9]+", sentence)
            for k in sentence:
                # Add values to Linked List
                x.add(k)
                # print(k)

        x.size()

        # Print Linked List
        # print('Book Total: ')
        # x.printList()

    with open('words-shuffled.txt', 'r') as file2:
        text = file2.readlines()

        y = LinkedList()

        count = 0

        for line in text:
            line = re.split("\n", line)
            for z in line:
                z = z.replace('_', '')
                if x.contains(z) == False:
                    count += 1
        print('Mismatches: ', count)

    # print('Added Text Total: ')
    # x.printList()

# If file is not present: return error
except FileNotFoundError:
    text = 'File 1 not found'