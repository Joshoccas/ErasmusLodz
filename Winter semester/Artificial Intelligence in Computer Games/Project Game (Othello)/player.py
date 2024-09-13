from othello import *

def insertPiecePlayer():

    # Lets the player choose which piece he/she wants to use
    # Returns a list with the player's piece as the first 
    # element and the opponent's piece as the second element

    piece = ''
    while not (piece == 'X' or piece == 'O'):
        print('Do you want to be X or O?')
        piece = input().upper()
    
    if piece == 'X':
        return ['X','O']
    else:
        return ['O','X']

def obtainPlayerPlay(board,piece):

    NUMBERS1TO8 = '1 2 3 4 5 6 7 8'.split()

    while True:
        play = input('Enter your play or type exit to finish the game. ').lower()
        if play == 'exit':
            return 'exit'
        
        if len(play) == 2 and play[0] in NUMBERS1TO8 and play[1] in NUMBERS1TO8:

            x = int(play[0]) - 1
            y = int(play[1]) - 1
            if isAValidPlay(board,piece,x,y) == False:
                continue
            else:
                break
        else:
            print('This play is not valid')
    
    return [x,y]