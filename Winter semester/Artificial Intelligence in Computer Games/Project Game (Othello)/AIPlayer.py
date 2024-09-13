from othello import *

MAXDEPTH = 4

def makeAPlay(board,piece,initx,inity):

    piecesToConvert = isAValidPlay(board,piece,initx,inity)

    if piecesToConvert == False:
        return False
    
    board[initx][inity] = piece
    for x,y in piecesToConvert:
        board[x][y] = piece
    return True


def obtainAIPlayerPlay(board,piece):

    validPlays = obtainValidPlays(board,piece)

    random.shuffle(validPlays)

    return validPlays[0]

def obtainAIPlayerPlay2(board,piece):

    x,y,value = minimax(board,0,True,piece)

    return [x,y]

def isGameOver(board):

    count = 0

    for x in range(8):
        for y in range(8):
            if board[x][y] != ' ':
                count += 1
    
    if count == 64:
        return True
    elif obtainValidPlays(board,'X') == [] or obtainValidPlays(board,'O') == []:
        return True
    else:
        return False

def countPieces(board, piece):

    total = 0

    for x in range(8):
        for y in range(8):
            if(board[x][y] == piece):
                total += 1
    
    return total

def countCorners(board, piece):

    total = 0

    if(board[0][0] == piece):
        total += 1
    
    if(board[0][7] == piece):
        total += 1
    
    if(board[7][0] == piece):
        total += 1
    
    if(board[7][7] == piece):
        total += 1
    
    return total

def countValues(board,piece):

    total = 0

    values = [
        [25, -5, 15, 10, 10, 15, -5, 25],
        [-5, -10, -4, 2, 2, -4, -10, -5],
        [15, -4, 3, 4, 4, 3, -4, 15],
        [10, 2, 4, 0, 0, 4, 2, 10],
        [10, 2, 4, 0, 0, 4, 2, 10],
        [15, -4, 3, 4, 4, 3, -4, 15],
        [-5, -10, -4, 2, 2, -4, -10, -5],
        [25, -5, 15, 10, 10, 15, -5, 25]
        ]
    
    for x in range(8):
        for y in range(8):
            if board[x][y] == piece:
                total += values[x][y]
    
    return total

def heuristic(board,piece):

    value = 0
    if piece == 'X':
        opponentPiece = 'O'
    else:
        opponentPiece = 'X'
    
    opponentPieces = countPieces(board,opponentPiece)
    pieces = countPieces(board,piece)

    if(opponentPieces == 0):
        value = float('inf')-1
    elif(pieces == 0):
        value = float('-inf')+1
    elif(isGameOver(board)):

        if(pieces > opponentPieces):
            value = float('inf')-1
        elif(pieces < opponentPieces):
            value = float('-inf')+1
    else:

        # First factor: How many pieces has each player?

        if(pieces > opponentPieces):
            value += 20*(pieces/(pieces + opponentPieces))
        elif(pieces < opponentPieces):
            value += -20*(opponentPieces/(pieces + opponentPieces))
        
        # Second factor: Possesion of the corners

        corners = countCorners(board,piece)
        opponentCorners = countCorners(board,opponentPiece)

        value += 500*(corners - opponentCorners) 
        
        
        # Third factor: Value of the positions occupied by each player

        valuePositionsPlayer = countValues(board,piece)
        valuePositionsOpponent = countValues(board,opponentPiece)
        valueTotal = valuePositionsPlayer + valuePositionsOpponent

        if valueTotal != 0:
            if valuePositionsPlayer > valuePositionsOpponent:
                value += 75*(valuePositionsPlayer/valueTotal)
            if valuePositionsOpponent > valuePositionsPlayer:
                value += -75*(valuePositionsOpponent/valueTotal)
            
    return value

def minimax(board,depth,maximizing,piece):

    if depth == MAXDEPTH or isGameOver(board):
        return -1, -1, heuristic(board,piece)

    if piece == 'X':
        opponentPiece = 'O'
    else:
        opponentPiece = 'X'

    xmove, ymove = -1,-1
    
    if maximizing == True:
        best_value = float('-inf')
        validPlays = obtainValidPlays(board,piece)
        for x,y in validPlays:

            copiedboard = copyBoard(board)
            makeAPlay(copiedboard,piece,x,y)
            _,_,value = minimax(copiedboard,depth+1,False,piece)
            if(value > best_value):
                best_value = value

                if(depth == 0):
                    xmove = x
                    ymove = y

        return xmove, ymove, best_value
    else:
        best_value = float('inf')
        validPlays = obtainValidPlays(board,opponentPiece)
        for x,y in validPlays:

            copiedboard = copyBoard(board)
            makeAPlay(copiedboard,opponentPiece,x,y)
            _,_,value = minimax(copiedboard,depth+1,True,piece)
            best_value = min(best_value,value)
    
        return -1, -1, best_value