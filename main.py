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
    inputA = str(board.board).replace('\'CA\'', '1').replace('\'CO\'', '0')

    output = list(prolog.query('flatten({},T),get_coin_to_flip(T,{},N)'.format(inputA,board.key)))
    coin = output[0]['N']
    board.flipCoin(coin)
    inputB = str(board.board).replace('\'CA\'', '1').replace('\'CO\'', '0')
    output2 = list(prolog.query('flatten({},T),solution(T,S)'.format(inputB)))


if __name__ == "__main__":
    board = Board()
    board.populateBoard()
    solution(board)