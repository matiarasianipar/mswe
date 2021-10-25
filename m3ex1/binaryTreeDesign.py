# Code uses the following sources:
# https://qvault.io/python/binary-search-tree-in-python/
# https://www.youtube.com/watch?v=f5dU3xoE6ms
# https://leetcode.com/problems/binary-tree-paths/solution/
# I'm prepared to explain and demonstrate my full understanding of this code


import re
import math

class BST():

    def __init__(self, data):
        self.root = data
        self.left = None
        self.right = None
        self.newNode = None
        self.wordCount = 0
        self.anotherWordCount = 0

    def contains(self, item):
        if self.root is None:
            return False
        if self.root == item:
            return True
        if item < self.root:
            if self.left is None:
                return False
            else:
                childLeft = self.left
                return childLeft.contains(item)
        if item > self.root:
            if self.right is None:
                return False
            else:
                childRight = self.right
                return childRight.contains(item)

    def add(self, item):
        if self.contains(item) == False:
            if self.root is None:
                self.wordCount += 1
                self.root = BST(item)
                return True
            else:
                if self.root > item:
                    if self.left is None:
                        self.wordCount += 1
                        self.left = BST(item)
                        return True
                    else:
                        self.left.add(item)
                else:
                    if self.right is None:
                        self.wordCount += 1
                        self.right = BST(item)
                        return True
                    else:
                        self.right.add(item)
        else:
            return False
            pass

    def DFS(self,root):
        self.DFSHelper(0,root)
        return self.anotherWordCount

    def DFSHelper(self, wordCount,root):
        if(root != None):
            self.anotherWordCount += 1
            if(root.left != None):
                self.DFSHelper(wordCount,root.left)
            if(root.right != None):
                self.DFSHelper(wordCount,root.right)



try:
    with open('pride-and-prejudice.txt', 'r') as file1:
        book = file1.readlines()

        x = BST('The')
        addCount = 0

        for sentence in book:
            sentence = re.split("[^a-zA-Z0-9]+", sentence)
            for k in sentence:
                # x.add(k)
                x.add(k.strip())
        # print(bookList)
        print("Book total: ")
        print(x.DFS(x))

    with open('words-shuffled.txt', 'r') as file2:
        text = file2.readlines()

        count = 0

        for line in text:
            line = re.split("\n", line)
            for z in line:
                z = z.replace('_', '')
                if x.contains(z) == False:
                    count += 1
        print('Mismatches: ', count)

except FileNotFoundError:
    text = 'File not found'