# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

from dominio import *
from tree_search import *
import time

total = 0
a = "08 ooooooooooooooEHooooCDEHoooBCDFIAAoBCDFIooooooGJooooooGJoooooooJ 34992 "
int_time= time.time()
novoMap = Map(a)               
novoDom = Domain(novoMap)
p = SearchProblem(novoDom, novoMap)
t = SearchTree(p, 'greedy')
t.search()
parcial = time.time() - int_time
total += parcial
print("Total: %f segundos" % total)