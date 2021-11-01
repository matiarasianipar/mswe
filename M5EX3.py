import collections

class Graph:
    # verticies
    verticies = 5
    
    # construct adjacency matrix
    matrix = []
    for i in range(5):
        for j in range(5):
            matrix.append([0, 0, 0, 0, 0])

    def __init__(self, x):
        self.verticies = x

        for i in range(0, 5):
            for j in range(0, 5):
                self.matrix[i - 1][j - 1] = 0
                self.matrix[j - 1][i - 1] = 0

    def displayAdjMatrix(self):
        print("\n Adjacency Matrix: \n")

        for i in range(0, self.verticies):
            print()
            for j in range(0, self.verticies):
                print("", self.matrix[i][j], end = "")
        print("\n")

    def addEdge(self, v1, v2):

        # check if vertex exists in graph
        if ((v1 - 1) >= self.verticies) or ((v2 - 1) >= self.verticies):
            print("Vertex out of range")

        # check if vertex is connecting to itself
        if (v1 == v2):
            print("Duplicate vertex")
        else:
            self.matrix[v1 - 1][v2 - 1] = 1
            self.matrix[v2 - 1][v1 - 1] = 1
            
    
    adjList = collections.defaultdict(list)
    nodeCount = 0

    # construct adjacency list 
    def adjMatToAdjList(self):

        for i in range(len(self.matrix)):
            for j in range(len(self.matrix[i])):
                if self.matrix[i][j] == 1:
                    self.adjList[i].append(j+1)
                    self.nodeCount += 1
        return self.adjList

    def displayAdjList(self):
        print("\n Adjacency List: \n")

        for i in range(len(self.adjList)):
            print(i+1, end = "")
            for j in self.adjList[i]:
                print(" -> {}".format(j), end ="")
            print()
        print("\n")
        print(self.nodeCount)

    incMat = []

    def adjListToIncMat(self):
        edges = int(self.nodeCount / 2)
        for i in range(5):
            self.incMat.append([0]*(edges))
        # for i in range(0, 5):
        #     for j in range(self.nodeCount):
        #         self.incMat[i - 1][j - 1] = 0
        #         self.incMat[j - 1][i - 1] = 0

        ctr = 0
        for i in range(0, 5):
            startPoint = i
            for j in range(len(self.adjList[i])):
                if (i+1 < self.adjList[i][j]):
                    endPoint = self.adjList[i][j]
                    self.incMat[startPoint][ctr] = 1
                    self.incMat[endPoint-1][ctr] = 1
                    ctr += 1               

    def displayIncMat(self):
        print("\n Incidence Matrix: \n")

        for i in range(0, self.verticies):
            print()
            for j in range(len(self.incMat[i])):
                print("", self.incMat[i][j], end = "")
        print("\n")
   
    adjList2 = collections.defaultdict(list)

    def incMatToAdjList(self):
        for j in range(len(self.incMat[0])):
            rowCtr = 0
            for i in range(0, 5):
                if self.incMat[i][j] == 1:
                    rowCtr += 1
                    if rowCtr == 1:
                        first_node = i
                    if rowCtr == 2:
                        second_node = i
                        self.adjList2[first_node].append(second_node+1)
                        self.adjList2[second_node].append(first_node+1)

    def displayAdjList2(self):
            print("\n Adjacency List: \n")

            for i in range(len(self.adjList2)):
                print(i+1, end = "")
                for j in self.adjList2[i]:
                    print(" -> {}".format(j), end ="")
                print()
            print("\n")
                            



            
    
Graph = Graph(5)

Graph.addEdge(1, 2)
Graph.addEdge(1, 5)
Graph.addEdge(2, 3)
Graph.addEdge(2, 4)
Graph.addEdge(2, 5)
Graph.addEdge(3, 2)
Graph.addEdge(3, 4)
Graph.addEdge(4, 5)

Graph.displayAdjMatrix()
Graph.adjMatToAdjList()
Graph.displayAdjList()
Graph.adjListToIncMat()
Graph.displayIncMat()
Graph.incMatToAdjList()
Graph.displayAdjList2()

