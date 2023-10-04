# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

from abc import ABC, abstractmethod
import time


class SearchDomain(ABC):

    # construtor
    @abstractmethod
    def __init__(self):
        pass

    # lista de accoes possiveis num estado
    @abstractmethod
    def actions(self, state):
        pass

    # resultado de uma accao num estado, ou seja, o estado seguinte
    @abstractmethod
    def result(self, state, action):
        pass

    # # custo de uma accao num estado
    # @abstractmethod
    # def cost(self, state, action):
    #     pass

    # # custo estimado de chegar de um estado a outro
    @abstractmethod
    def heuristic(self, state):
        pass

class SearchProblem:
    def __init__(self, domain, initial):
        self.domain:Domain = domain     
        self.initial:Map = initial      

    def goal_test(self, state):
        return self.domain.satisfies(state)

class SearchNode:
    def __init__(self, state, parent, heuristic = 0, action = None):
        self.state = state
        self.parent = parent
        self.action = action
        self.heuristic = heuristic  

    def __str__(self):
        return f"no({self.state})"

    def __repr__(self):
        return str(self)

class SearchTree:

    # construtor
    def __init__(self, problem, strategy='breadth'):
        self.problem = problem
        root = SearchNode(problem.initial, None, self.problem.domain.heuristic(self.problem.domain.current_map))  # Criação do nó raiz
        self.open_nodes = [root]
        self.strategy = strategy
        self.solution = None
        self.statesVisited = set()

    # obter o caminho (sequencia de estados) da raiz ate um no
    def listaDeAcoes(self, node):
        actions = []
        while node.parent != None:
            actions.insert(0, node.action)                              # Adiciona à frente da lista
            node = node.parent
        return actions

    def search(self) -> list:                                         
        while not len(self.open_nodes) == 0:     
            node = self.open_nodes.pop(0)                               
            self.statesVisited.add(node.state.__repr__())                  
            if self.problem.goal_test(node.state):                     
                self.solution = node                                    
                return self.listaDeAcoes(node)                          
            
            lnewnodes = []
            for a in self.problem.domain.actions(node.state):
                newstate = self.problem.domain.result(node.state, a)    
                aux = newstate.__repr__()                              
                if aux not in self.statesVisited:                         
                    newnode = SearchNode(newstate, node, self.problem.domain.heuristic(newstate),a)
                    lnewnodes.append(newnode)
                    self.statesVisited.add(aux)  
                    
            self.add_to_open(lnewnodes)      
            
        return None

    # juntar novos nos a lista de nos abertos de acordo com a estrategia
    def add_to_open(self, lnewnodes):
        if self.strategy == 'breadth':
            self.open_nodes.extend(lnewnodes)
        elif self.strategy == 'depth':
            self.open_nodes[:0] = lnewnodes
        elif self.strategy == 'uniform':
            self.open_nodes.extend(lnewnodes)
            self.open_nodes.sort(key=lambda node: node.cost)
        elif self.strategy == 'greedy':
            self.open_nodes.extend(lnewnodes)
            self.open_nodes.sort(key=lambda node: node.heuristic)
        elif self.strategy == 'a*': 
            self.open_nodes= sorted(self.open_nodes + lnewnodes, key = lambda node: node.cost + node.heuristic)