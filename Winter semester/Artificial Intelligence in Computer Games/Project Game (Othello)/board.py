# board.py

def drawBoard(board):

    HLINE = ' +--------+'
    print('  12345678')
    print(HLINE)
    for x in range(8):
        print('%s|' % (x+1), end='')
        for y in range(8):
            print(board[x][y], end='')
        print('|')
    print(HLINE)


def newBoard():

    board = [[' ' for _ in range(8)] for _ in range(8)]
    for x in range(8):
        for y in range(8):
            board[x][y] = ' '
    
    return board

def restartBoard(board):

    for x in range(8):
        for y in range(8):
            board[x][y] = ' '
    
    board[3][3] = 'X'
    board[3][4] = 'O'
    board[4][3] = 'O'
    board[4][4] = 'X'

def copyBoard(board):

    copiedBoard = newBoard()

    for x in range(8):
        for y in range(8):
            copiedBoard[x][y] = board[x][y]
    
    return copiedBoard
