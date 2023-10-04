# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

from math import dist
from tree_search import *
from common2 import Coordinates, Map

class Domain:
    def __init__(self, mapa: Map):
        self.current_map: Map = mapa

    def actions(self, mapa: Map):
        # Devolve um array de todos os movimentos possíveis de todos os carros
        movCarros = []
        carros = []
        coordenadas = mapa.coordinates
        for x, y, car in coordenadas:
            if car not in carros and car != "x":
                carros.append(car) 
                [movCarros.append(action) for action in mapa.car_actions(car)]
        return movCarros

    def result(self, mapa: Map, action):
        # Devolve um mapa com o resultado de uma ação
        vetor = (
            Coordinates(-1, 0)
            if action[1] == "a"
            else Coordinates(1, 0)
            if action[1] == "d"
            else Coordinates(0, -1)
            if action[1] == "w"
            else Coordinates(0, 1)
        )

        novoMapa = Map(mapa.__repr__())  # criamos para o pai não ser alterado
        novoMapa.move(action[0], vetor)

        return novoMapa

    def satisfies(self, mapa: Map):
        return mapa.test_win()
    

    def heuristic(self, mapa: Map):
        
        #return self.heuristic1(mapa)
        return len(self.heuristic2(mapa))
        #return self.heuristic3(mapa)

    def heuristic1(self, mapa: Map):
        #print(mapa.grid_size - mapa.piece_coordinates("A")[1].x)
        return (mapa.grid_size - mapa.piece_coordinates("A")[1].x)  

    def heuristic2(self, mapa: Map):
        blockingCars = []
        grid = mapa.grid
        if mapa.grid_size == 4 or mapa.grid_size == 6:
            linhaA = grid[2]
        else:
            linhaA = grid[4]

        coords_A = mapa.piece_coordinates("A")[0].x
        for letra in linhaA:
            if letra != "x" and letra != "o" and letra != "A":
                if (coords_A - mapa.piece_coordinates(letra)[0].x)<0:
                    blockingCars.append(letra)
        #print(blockingCars)
        return blockingCars

    def heuristic3(self, mapa: Map):
        points = 0
        blockingCars = self.heuristic2(mapa)
        for car in blockingCars:
            if len(mapa.car_actions(car)) == 0:
                points += 2
            else:
                points += 1
        #print(points)
        return points

    def cost(self, mapa: Map):
        return 
