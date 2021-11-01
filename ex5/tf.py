# https://docs.python.org/3/library/multiprocessing.html
# https://stackoverflow.com/questions/8804830/python-multiprocessing-picklingerror-cant-pickle-type-function
# https://www.geeksforgeeks.org/how-to-use-threadpoolexecutor-in-python3/

import re, sys, collections
from concurrent.futures import ThreadPoolExecutor
from multiprocessing.pool import ThreadPool as Pool
import threading

class TermFrequeuncy:

    def startPoolExecutor(self):


        def countFile(fileName):
            print("Started: ", fileName)
            print(threading.current_thread().getName())
            
            stopwords = set(open('stop_words').read().split(','))
            words = re.findall('\w{3,}', open(fileName).read().lower())
            self.counts += collections.Counter(w for w in words if w not in stopwords)

            print("Ended: ", fileName)

        
        self.counts = collections.Counter()
        listofargs = ['anonymit.txt','cDc-0200.txt','crossbow.txt','gems.txt']

        with ThreadPoolExecutor(max_workers=5) as pool:
            try:
                pool.map(countFile, (listofargs))
            except:
                print('generated exception')
        # with Pool(10) as pool:
        #     pool.map(countFile, ['anonymit.txt','cDc-0200.txt','crossbow.txt','gems.txt'])

        print("---------- Word counts (top 40) -----------\n")
        for (w, c) in self.counts.most_common(40):
            print(w, '-', c)

if __name__ == "__main__":
    fc = TermFrequeuncy()
    fc.startPoolExecutor()
