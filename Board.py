from numpy.random import randint

class Board():
    def __init__(self):
        """
        Inicializa um tabuleiro 8x8.
        """
        self.board = [
            ['  ' for _ in range(8)] for _ in range(8)
        ]
        self.key = f"{randint(0,64)}"
        self.isPopulated = False
    
    def printBoard(self):
        """
        Reproduz o tabuleiro na linha de comando 
        com suas posições.
        """
        i = 0
        for l in self.board:
            print("+" + "------+"*8)
            print("|" + "      |"*8)
            print(("|" + 8*"  {:02d}  |").format(*[(2**3)*i+n for n in range(8)]))
            i += 1
        print("+" + "------+"*8)

    def printBoardBinary(self):
        """
        Reproduz o tabuleiro na linha de comando 
        com suas posições em binário.
        """
        i = 0
        for l in self.board:
            print("+" + "------+"*8)
            print("|" + "      |"*8)
            print(("|" + 8*"{:06b}|").format(*[(2**3)*i+n for n in range(8)]))
            i += 1
        print("+" + "------+"*8)

    def populateBoard(self):
        """
        Preenche o tabuleiro com moedas.
        CA para cara CO para coroa
        """
        for l in range(8):
            for c in range(8):
                self.board[l][c] = 'CA' if randint(0,10)%2 else 'CO'
        
        self.isPopulated = True
        print('Tabuleiro Preenchido.')

    def printPopulatedBoard(self):
        """
        Reproduz o tabuleiro na linha de comando 
        com as moedas.
        """
        for l in self.board:
            print("+" + "------+"*8)
            print("|" + "      |"*8)
            print(("|" + 8*"  {}  |").format(*[coin for coin in l]))
        print("+" + "------+"*8)

    def resetBoard(self):
        """
        Reseta o tabuleiro para o estado vazio.
        """

        self.board = [
            ['  ' for _ in range(8)] for _ in range(8)
        ]
        self.key = f"{randint(0,64)}"
        self.isPopulated = False
        print('Tabuleiro resetado.')
    
    def flipCoin(self,coin):
        """
        Vira a moeda escolhida.
        """
        if self.isPopulated:
            binary = "{:06b}".format(coin)
            line = binary[0:3]
            column = binary[3:]
            line = sum([2**i*int(line[2-i]) for i in range(3)])
            column = sum([2**i*int(column[2-i]) for i in range(3)])
            self.board[line][column] = 'CA' if self.board[line][column] == 'CO' else 'CO'
            
            print(f'Moeda de casa {coin} Virada.')
        else:
            print('Tabuleiro não foi preenchido.')