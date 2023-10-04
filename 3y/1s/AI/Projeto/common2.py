# Authors:
# Rafael Amorim, 98197
# Tiago Alves, 104110

"""Common data structures. Can be used by any module."""
from __future__ import annotations

import math
from dataclasses import dataclass


@dataclass
class Coordinates:
    """Coordinates data class."""

    x: int
    y: int


class MapException(Exception):
    """Exception Moving Pieces."""


class Map:
    """Representation of a map."""

    empty_tile = "o"
    wall_tile = "x"
    player_car = "A"

    def __init__(self, txt: str):           
        """Initialize Map from string."""
        text = txt.split(" ")
        if len(text) == 3:
            pieces, grid, movements = txt.split(" ")
        else:
            pieces, grid, movements,a = txt.split(" ")
        self.pieces = int(pieces)
        self.movements = int(movements)
        self.grid_size = int(math.sqrt(len(grid)))
        self.grid_text = grid
        self.grid = []

        line = []
        for i, pos in enumerate(grid):
            line.append(pos)
            if (i + 1) % self.grid_size == 0:
                self.grid.append(line)
                line = []

    def __repr__(self):
        """Revert map object to string."""
        raw = "".join([column for line in self.grid for column in line])
        return f"{self.pieces} {raw} {self.movements}"

    def __eq__(self, other: Map)-> bool:        # Tentativa crazy car
        if not isinstance(other, Map):
            return NotImplemented
        return self.grid_text == other.grid_text

    @property
    def coordinates(self): # retorna uma lista de tuplos de 3 elementos (x,y,piece)
        """Representation of ocupied map positions through tuples x,y,value."""
        return [(x, y, column) for y, line in enumerate(self.grid) for x, column in enumerate(line) if column != self.empty_tile]

    def get(self, cursor: Coordinates):
        """Return piece at cursor position."""
        if 0 <= cursor.x < self.grid_size and 0 <= cursor.y < self.grid_size:
            return self.grid[int(cursor.y)][int(cursor.x)]
        raise MapException("Out of the grid")

    def piece_coordinates(self, piece: str):
        """List coordinates holding a piece."""
        return [Coordinates(x, y) for (x, y, p) in self.coordinates if p == piece]

    def move(self, piece: str, direction: Coordinates):
        """Move piece in direction fiven by a vector."""
        if piece == self.wall_tile:
            raise MapException("Blocked piece")

        piece_coord = self.piece_coordinates(piece)

        # Don't move vertical pieces sideways
        if direction.x != 0 and any([line.count(piece) == 1 for line in self.grid]):
            raise MapException("Can't move sideways")
        # Don't move horizontal pieces up-down
        if direction.y != 0 and any([line.count(piece) > 1 for line in self.grid]):
            raise MapException("Can't move up-down")

        def sum(a: Coordinates, b: Coordinates):
            return Coordinates(a.x + b.x, a.y + b.y)

        for pos in piece_coord:
            if not self.get(sum(pos, direction)) in [piece, self.empty_tile]:
                raise MapException("Blocked piece")

        for pos in piece_coord:
            self.grid[pos.y][pos.x] = self.empty_tile

        for pos in piece_coord:
            new_pos = sum(pos, direction)
            self.grid[new_pos.y][new_pos.x] = piece

    def test_win(self):
        """Test if player_car has crossed the left most column."""
        return any(
            [c.x == self.grid_size - 1 for c in self.piece_coordinates(self.player_car)]
        )

    def car_actions(self, piece: str) -> list[tuple[str, str]]:
        diretion = self.get_car_diretion(piece)
        piece_coords: list[Coordinates] = self.piece_coordinates(piece)
        l_act = []
        if diretion == 'h': #horizontal
            left_point = piece_coords[0]
            right_point = piece_coords[-1]
            try:
                left_point.x = left_point.x - 1
                a_esquerda = self.get(left_point)
                l_act.append((piece,'a')) if a_esquerda == 'o' else None
            except:
                pass
            try:
                right_point.x = right_point.x + 1
                righta = self.get(right_point)
                l_act.append((piece,'d')) if righta == 'o' else None
            except:
                pass
        else: #vertical
            up_point = piece_coords[0]
            down_point = piece_coords[-1]
            try:
                up_point.y = up_point.y - 1
                upa = self.get(up_point)
                l_act.append((piece,'w')) if upa == 'o' else None
            except:
                pass
            try:
                down_point.y = down_point.y + 1
                downa = self.get(down_point)
                l_act.append((piece,'s')) if downa == 'o' else None
            except:
                pass
        return l_act

    def get_car_diretion(self, car: str) -> str:
        '''Returns "horizontal" if car has two coordinates with equal y  else "vertical"'''
        idx = self.grid_text.find(car)      # Encontra a posição do carro na grid_txt dá um int
        if self.grid_text[idx + 1] == car:  # Carros horizontais aparecem na grid_txt com os caracteres todos juntos
            return "h"
        return "v"

    def print(self):
        [print(x) for x in self.grid]


""" TODO move to tests
m = Map("02 ooooBoooooBoAAooBooooooooooooooooooo 14")
print(m)
print(m.get(Dimensions(4,0)))
assert m.move("A", Coordinates(1, 0))
assert m.move("A", Coordinates(-1, 0))
assert not m.move("A", Coordinates(0, 1))
assert not m.move("A", Coordinates(0, -1))
assert m.move("B", Coordinates(0, 1))
assert m.move("B", Coordinates(0, -1))
assert not m.move("B", Coordinates(1,0))
assert not m.move("B", Coordinates(-1,0))
print(m)
"""