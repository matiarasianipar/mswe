# Code uses the following sources:
# https://www.youtube.com/watch?v=AU_GBuaW00Y
# https://www.youtube.com/watch?v=w9JhOKb4tyk
# I'm prepared to explain and demonstrate my full understanding of this code

import re

class MyHashSet():

    def __init__(self):
        self.keyRange = 769
        self.bucketArray = [Bucket() for i in range(self.keyRange)]
        self.size = 0

    def add(self, key):
        if self.contains(key) == False:
            if key is not None:
                bucketIndex = self.hash(key)
                self.bucketArray[bucketIndex].insert(key)
                self.size += 1
                return True
            else:
                return False
        else:
            return False

    def hash(self, key):
        bucketIndex = hash(key) % self.keyRange
        return bucketIndex

    def contains(self, key):
        bucketIndex = self.hash(key)
        return self.bucketArray[bucketIndex].exists(key)

    def count(self):
        print('Book total: ', self.size)

class Node:

    def __init__(self, value, nextNode = None):
        self.value = value
        self.next = nextNode

class Bucket:

    def __init__(self):
        self.head = Node(0)

    def insert(self, newValue):
        if not self.exists(newValue):
            newNode = Node(newValue, self.head.next)
            self.head.next = newNode

    def exists(self, value):
        curr = self.head.next
        while curr is not None:
            if curr.value == value:
                return True
            curr = curr.next
        return False

try:
    with open('pride-and-prejudice.txt', 'r') as file1:
        book = file1.readlines()

        x = MyHashSet()
        # count = 0

        for sentence in book:
            sentence = re.split("[^a-zA-Z0-9]+", sentence)
            for k in sentence:
                k = k.strip('')
                x.add(k)
                # if x.add(k) == True:
                    # count += 1
        #             print(k)
        # print(count)
        x.count()

        # print(bookList)

    with open('words-shuffled.txt', 'r') as file2:
        text = file2.readlines()

        mismatchcount = 0
        listComp = []

        for line in text:
            line = re.split("\n", line)
            for z in line:
                z = z.replace('_', '')
                if (z != ''):
                    listComp.append(z)

        for each in listComp:
            if x.contains(each) == False:
                mismatchcount += 1
                # print(each)
        print('Mismatches: ', mismatchcount)

except FileNotFoundError:
    text = 'File not found'