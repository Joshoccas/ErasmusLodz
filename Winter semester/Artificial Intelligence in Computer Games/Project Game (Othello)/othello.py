import random
import sys
from board import *

def isItOnTheBoard(x,y):

    return x >= 0 and x <= 7 and y>= 0 and y <= 7

def isItACorner(x,y):

    return (x == 0 and y == 0) or (x == 7 and y == 0) or (x == 0 and y == 7) or (x == 7 and y == 7)

def isAValidPlay(board, piece, initx, inity):

    # First we check if the coordinates belong to an empty legal position

    if board[initx][inity] != ' ' or not isItOnTheBoard(initx,inity):
        return False
    
    # We put the piece in the position temporarily

    board[initx][inity] = piece

    if piece == 'X':
        opponentPiece = 'O'
    else:
        opponentPiece = 'X'
    
    piecesToConvert = []

    for directionx, directiony in [[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]]:

        x,y = initx,inity
        x += directionx # first step in the direction
        y += directiony # first step in the direction

        if isItOnTheBoard(x,y) and board[x][y] == opponentPiece:

            x += directionx
            y += directiony

            if not isItOnTheBoard(x,y):
                continue
            while board[x][y] == opponentPiece:
                x += directionx
                y += directiony
                if not isItOnTheBoard(x,y): break
            if not isItOnTheBoard(x,y):
                continue
            if board[x][y] == piece:

                 # There are pieces to convert

                while True:
                    x -= directionx
                    y -= directiony

                    if x == initx and y == inity:
                        break
                    piecesToConvert.append([x,y])
    
    board[initx][inity] = ' '
    if len(piecesToConvert) == 0:
        return False
    
    return piecesToConvert

def obtainValidPlays(board,piece):

    validPlays = []

    for x in range(8):
        for y in range(8):
            if isAValidPlay(board,piece,x,y) != False:
                validPlays.append([x,y])
    return validPlays

def obtainBoardWithValidPlays(board,piece):

    copiedBoard = copyBoard(board)

    for x,y in obtainValidPlays(copiedBoard,piece):
        copiedBoard[x][y] = '.'
    
    return copiedBoard