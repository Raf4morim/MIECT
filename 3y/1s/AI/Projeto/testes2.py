# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

from dominio import *
from tree_search import *
import time

with open("levels.txt", "r") as f:
    a = f.read()

total = 0

for grid in a.split("\n"):
    int_time= time.time()
    novoMap = Map(grid)               
    novoDom = Domain(novoMap)
    p = SearchProblem(novoDom, novoMap)
    t = SearchTree(p, 'greedy')
    t.search()
    nivel = grid.split(" ")[0]
    parcial = time.time() - int_time
    print("Nivel %2d tem %f segundos" % (int(nivel), parcial))
    total += parcial
print("Total: %f segundos" % total)