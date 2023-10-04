# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

from dominio import *
from tree_search import *
import time


inputfile = input("Escreva o nome do ficheiro: ")

with open("levels.txt", "r") as f:
    a = f.read()

total_time = 0
with open(inputfile, 'w') as file:
    print('Nivel\t\tTempo\t\tNos\n')
    file.write('Nivel,Tempo,Nos\n')
    for grid in a.split("\n"):
        int_time= time.time()
        novoMap = Map(grid)
        novoDom = Domain(novoMap)
        p = SearchProblem(novoDom, novoMap)
        t = SearchTree(p, 'greedy')
        t.search()
        length = len(t.statesVisited)
        nivel = grid.split(" ")[0]
        parcial = time.time() - int_time
        total_time += parcial
        file.write('%d,%f,%d' % (int(nivel), parcial, length))
        print('%d\t\t%f\t\t%d' % (int(nivel), parcial, length))
        file.write('\n')
    file.write('Tempo Total: %f' % total_time)
file.close()