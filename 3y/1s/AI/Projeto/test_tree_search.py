# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

from common2 import Coordinates, Map
from dominio import Domain
from tree_search import SearchTree, SearchProblem, SearchNode, SearchDomain

a = Map("03 ooBoooooBooCAABooCoooooooooooooooooo 62")

a.print()
print(a.test_win())
b = Domain(a)

a = Map("03 ooBoooooBooCAABooCoooooooooooooooooo 62") 
b = SearchProblem(Domain(a),a)

t = SearchTree(b,'breadth')
print(t.search())

print(a.test_win())

acao=t.search()[0]

print(a.piece_coordinates(acao[0]))