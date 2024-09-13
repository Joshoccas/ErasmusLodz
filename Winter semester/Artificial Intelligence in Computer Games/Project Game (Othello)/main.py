from othello import *
from board import *
from AIPlayer import *
from player import *
from scores import *

def whoStarts():

    if random.randint(0,1) == 0:
        return 'AIPlayer'
    else:
        return 'Player'

def playAgain():

    print('Do you want to play again?')
    return input().lower().startswith('y')

print('OTHELLO GAME')

while True:

    mainBoard = newBoard()
    restartBoard(mainBoard)
    piecePlayer, pieceAIPlayer = insertPiecePlayer()
    turn = whoStarts()

    print(turn + ' will go first.')

    while True:

        if turn == 'Player':

            boardWithValidPlays = obtainBoardWithValidPlays(mainBoard, piecePlayer)
            drawBoard(boardWithValidPlays)
            showScores(piecePlayer,pieceAIPlayer, mainBoard)
            play = obtainPlayerPlay(mainBoard,piecePlayer)

            if play == 'exit':
                print('Thanks for playing!')
                sys.exit()
            else:
                makeAPlay(mainBoard, piecePlayer, play[0], play[1])
            
            if obtainValidPlays(mainBoard, pieceAIPlayer) == []:
                break
            else:
                turn = 'AIPlayer'
        else:

            drawBoard(mainBoard)
            showScores(piecePlayer, pieceAIPlayer, mainBoard)
            input('Press enter to see the play of the AIPlayer.')
            x, y = obtainAIPlayerPlay2(mainBoard, pieceAIPlayer)
            makeAPlay(mainBoard, pieceAIPlayer, x, y)

            if obtainValidPlays(mainBoard, piecePlayer) == []:
                break
            else:
                turn = 'Player'
    
    drawBoard(mainBoard)
    scores = obtainScores(mainBoard)
    print('X has obtained %s points. O has obtained %s points.' % (scores['X'], scores['O']))

    if scores[piecePlayer] > scores[pieceAIPlayer]:
        print('You have beaten the AIPlayer with a difference of %s points! Congratulations!' %
        (scores[piecePlayer] - scores[pieceAIPlayer]))
    elif(scores[piecePlayer] < scores[pieceAIPlayer]):
        print('You have lost. The AIPlayer has beaten you with a difference of %s points.' %
        (scores[pieceAIPlayer] - scores[piecePlayer]))
    else:
        print('It is a draw!')
    
    if not playAgain():
        break