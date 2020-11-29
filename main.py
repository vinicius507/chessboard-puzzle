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

    tabuleiro_prisioneiro_1 = str(board.board).replace('\'CA\'', '1').replace('\'CO\'', '0')
    output = list(prolog.query('flatten({},T),get_coin_to_flip(T,{},R)'.format(tabuleiro_prisioneiro_1,board.key)))
    board.flipCoin(output[0]['R'])
    
    tabuleiro_prisioneiro_2 = str(board.board).replace('\'CA\'', '1').replace('\'CO\'', '0')
    output_2 = list(prolog.query('flatten({},T),solution(T,S)'.format(tabuleiro_prisioneiro_2)))
    board.check(output_2[0]['S'])

if __name__ == "__main__":
    board = Board()
    board.populateBoard()
    print('A chave está na casa: {}'.format(board.key))
    print('------------------------TABULEIRO------------------------')
    board.printPopulatedBoard()
    solution(board)