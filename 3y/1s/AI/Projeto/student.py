# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

"""Example client."""
import asyncio
import getpass
import json
import os
from random import randint
from dominio import *
from tree_search import *
import math
import sys



import websockets
from common2 import Coordinates, Map


def vaiPoCarro(cursor: Coordinates, m: Map, a): # testado
    """Send cursor to coordinates."""

    # car1_x - lado esquerdo carro
    # car1_y - parte de cima carro
    # car2_x - lado direito carro
    # car2_y - parte de baixo carro
    # car1 e car2 é o mesmo carro, de comprimento 2
    car1_x = m.piece_coordinates(a[0])[0].x
    car1_y = m.piece_coordinates(a[0])[0].y
    car2_x = m.piece_coordinates(a[0])[1].x
    car2_y = m.piece_coordinates(a[0])[1].y
    
    hipotenusa1 = math.sqrt((car1_x - cursor.x)**2 + (car1_y - cursor.y)**2)
    hipotenusa2 = math.sqrt((car2_x - cursor.x)**2 + (car2_y - cursor.y)**2)
    distMin = min(hipotenusa1, hipotenusa2)
    if len(m.piece_coordinates(a[0])) == 3:
        # car3 é carro de comprimento 3, ponta direita
        car3_x = m.piece_coordinates(a[0])[2].x
        car3_y = m.piece_coordinates(a[0])[2].y
        hipotenusa3 = math.sqrt((car3_x - cursor.x)**2 + (car3_y - cursor.y)**2)
        distMin = min(hipotenusa1, hipotenusa2, hipotenusa3)
        if distMin == hipotenusa3:
            car_x = car3_x
            car_y = car3_y

    if distMin == hipotenusa1:
        car_x = car1_x
        car_y = car1_y
            
    elif distMin == hipotenusa2:
        car_x = car2_x
        car_y = car2_y

    if cursor.x < car_x:
        return "d"
    if cursor.x > car_x: 
        return "a"
    if cursor.y > car_y:
        return "w"
    if cursor.y < car_y:
        return "s"
    return " "

def cursorOnCar(cursor: Coordinates, m: Map, a):
    if cursor.x == m.piece_coordinates(a[0])[0].x and cursor.y == m.piece_coordinates(a[0])[0].y or cursor.x == m.piece_coordinates(a[0])[1].x and cursor.y == m.piece_coordinates(a[0])[1].y or cursor.x == m.piece_coordinates(a[0])[2].x and cursor.y == m.piece_coordinates(a[0])[2].y:
        return True
    return False
    
def carSelected(selecionado):
    """Check if cursor is selected on something."""
    if selecionado != "":
        return True
    return False

def entrada(selected, coords_cursor, m, carro, listaCaminhos): 
    if selected == carro[0]:
        if cursorOnCar(coords_cursor, m, carro):
            listaCaminhos.pop(0)
            return carro[1] 
    else:
        if carSelected(selected): 
            return " "    
    return vaiPoCarro(coords_cursor, m, carro)
    

async def agent_loop(server_address="localhost:8000", agent_name="student"):
    """Example client loop."""
    async with websockets.connect(f"ws://{server_address}/player") as websocket:
        
        agent_name="104110_98197"
        # Receive information about static game properties
        await websocket.send(json.dumps({"cmd": "join", "name": agent_name}))

        carAndAction = []
        while True:
            try:
                
                # compare if actual grid is equal to expected grid from last iteration
                # if it isn't, there has happened a crazy step and must be reverted
                
                state = json.loads(await websocket.recv())  # receive game update, this must be called timely or your game will get out of sync with the server

                key=""
                expected_grid = Map(state.get("grid"))           
                novoDom = Domain(expected_grid)
                p = SearchProblem(novoDom, expected_grid)
                t = SearchTree(p, 'greedy')           

                if carAndAction==[]:               
                    carAndAction = t.search() 
                    key = entrada(state.get("selected"),Coordinates(state.get("cursor")[0], state.get("cursor")[1]), Map(state.get("grid")), carAndAction[0], carAndAction)            
                else:
                    # TENTATIVA DE SOLUCIONAR CRAZY CAR
                    # if not expected_grid.__eq__(anterior_grid) and not (state.get("selected") and key != " "):
                    #     print("\nCrazy step")
                        
                    #     # para cada peça ver se coordinates mudaram
                    #     a = anterior_grid.coordinates
                    #     e = expected_grid.coordinates
                        
                    #     # print("a: ",a)
                    #     # print("e: ",e)
                    #     # acao = ""
                    #     aaaa = ('','')
                    #     for x2,y2,piece2 in e:
                    #         for x,y,piece in a:
                    #             if (x2,y2,piece2) not in a and (x,y,piece) not in e:
                    #                 antes = (x,y,piece)
                    #                 depois = (x2,y2,piece2)
                    #                 print("antes: ",antes)
                    #                 print("depois: ",depois)
                    #                 subx = x2-x
                    #                 suby = y2-y

                    #                 if subx == 2 or subx == 3:
                    #                     acao = "d"
                    #                 elif subx == -2 or subx == -3:
                    #                     acao = "a"
                    #                 elif suby == 2 or suby == 3:
                    #                     acao = "s"
                    #                 elif suby == -2 or suby == -3:
                    #                     acao = "w"

                    #                 aaaa = (piece,acao)
                    #                 print("aaaa: ",aaaa, "!= carAndAction[0]",carAndAction[0])

                    key = entrada(state.get("selected"),Coordinates(state.get("cursor")[0], state.get("cursor")[1]), Map(state.get("grid")), carAndAction[0], carAndAction)
                
                await websocket.send(json.dumps({"cmd": "key", "key": key}))
                #anterior_grid = expected_grid
                
            except websockets.exceptions.ConnectionClosedOK:
                print("Server has cleanly disconnected us")
                return

# DO NOT CHANGE THE LINES BELLOW
# You can change the default values using the command line, example:
# $ NAME='arrumador' python3 client.py
loop = asyncio.get_event_loop()
SERVER = os.environ.get("SERVER", "localhost")
PORT = os.environ.get("PORT", "8000")
NAME = os.environ.get("NAME", getpass.getuser())
loop.run_until_complete(agent_loop(f"{SERVER}:{PORT}", NAME))
