def obtainScores(board):

    scoreX = 0
    scoreO = 0
    for x in range(8):
        for y in range(8):
            if board[x][y] == 'X':
                scoreX += 1
            if board[x][y] == 'O':
                scoreO += 1
    return {'X':scoreX, 'O':scoreO}

def showScores(piece1, piece2, board):

    scores = obtainScores(board)
    print('You have %s points. Your opponent has %s points.' %
    (scores[piece1], scores[piece2]))