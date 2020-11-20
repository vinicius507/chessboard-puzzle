from pyswip import *
from Board import Board

def solution(board):
    """
    Função auxiliadora para enviar a lista em formato Prolog
    para o arquivo main.pl, responsável pelo algorítimo a
    ser demonstrado.
    """
    prolog = Prolog()
    prolog.consult('main.pl')
    board = str(board.board).replace('CA', '1').replace('CO', '0')

    # É preciso enviar o tabuleiro e a posição da chave 
    # para o main.pl

    # solution = prolog.query("solution({},{})".format(board, ))

    print(list(prolog.query("flatten({})".format(board))))

if __name__ == "__main__":
    board = Board()
    board.populateBoard()
    solution(board)