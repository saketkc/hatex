import sys
import copy

ROW_MOVES = (-1,0,1,0)
COL_MOVES = (0,1,0,-1)


def get_opponent(player):
    if player == 'X':
        return 'O'
    elif player == 'O':
        return 'X'
    else:
        raise RuntimeError('X or O?')


def AlphaBeta(board, player):
    max_score = -1000*board.n*board.n
    alpha = -1000*board.n*board.n
    beta = 1000*board.n*board.n
    opti = None
    optj = None
    board.enque_choices(player)
    possible_moves = board.possible_moves
    for position in possible_moves:
        board_new = copy.deepcopy(board)
        i,j = position
        board_new.run_play(player, i, j)
        score = Min(board_new, get_opponent(player), 1, alpha, beta)
        if alpha<score:
            alpha = score
        if score>max_score:
            max_score = score
            opti = i
            optj = j
    return opti, optj


def MiniMax(board, player):
    max_score = -1000*board.n*board.n
    opti = None
    optj = None
    board.enque_choices(player)
    possible_moves = board.possible_moves
    if len(possible_moves):
        possible_moves.reverse()
    for position in possible_moves:
        board_new = copy.deepcopy(board)
        i,j = position
        board_new.run_play(player, i, j)
        score = Min(board_new, get_opponent(player), 1)
        if score>max_score:
            max_score = score
            opti = i
            optj = j
    return opti, optj


def Min(board, player, depth, alpha=None, beta=None):
    if depth>=board.depth:
        return board.evaluate()
    board.enque_choices(player)
    min_score = 1000*board.n*board.n
    for position in board.possible_moves:
        board_new = copy.deepcopy(board)
        i,j = position
        board_new.run_play(player, i, j)
        score = Max(board_new, get_opponent(player), depth+1)
        if alpha is not None and beta is not None:
            if score <= alpha:
                return score
            if beta>score:
                beta = score
        if score<min_score:
            min_score = score
    return min_score

def Max(board, player, depth, alpha=None, beta=None):
    if depth>=board.depth:
        return board.evaluate()
    board.enque_choices(player)
    max_score = -1000*board.n*board.n
    for position in board.possible_moves:
        board_new = copy.deepcopy(board)
        i,j = position
        board_new.run_play(player, i, j)
        score = Min(board_new, get_opponent(player), depth+1)
        if alpha is not None and beta is not None:
            if score >= beta:
                return score
            if alpha<score:
               alpha = score
        if score>max_score:
            max_score = score
    return max_score

class Input(object):
    def __init__(self, filepath):
        self.filepath = filepath
        self.n = None
        self.mode = None
        self.iplay = None
        self.depth = None
        self.values = None
        self.state = None
        self._read()

    def _read(self):
        lines = tuple(open(self.filepath).read().splitlines())
        self.n = int(lines[0])
        self.mode = lines[1]
        self.iplay = lines[2]
        self.depth = int(lines[3])
        cell_value_lines = lines[4:self.n+4]
        board_state_lines = lines[self.n+4:]
        cell_values = tuple(x.split(' ') for x in cell_value_lines)
        self.values = [list(map(int, row)) for row in cell_values]
        self.state = tuple(list(x) for x in board_state_lines)
        self.possible_moves = []

    def enque_choices(self, player):
        opponent = get_opponent(player)
        n = self.n
        state = self.state
        possible_moves = []
        for i in range(0,n):
            for j in range(0,n):
                if state[i][j] == '.':
                    opponentcount = 0
                    playercount = 0
                    for k in range(0, 4):
                        row_move = i+ROW_MOVES[k]
                        col_move = j+COL_MOVES[k]
                        if row_move<0 or row_move>=n or col_move<0 or col_move>=n:
                            continue
                        if state[row_move][col_move]==player:
                            playercount+=1
                        elif state[row_move][col_move]==opponent:
                            opponentcount+=1
                    if opponentcount or playercount:
                        possible_moves.append((i,j))
                    else:
                        possible_moves = [(i,j)] + possible_moves[:]
        self.possible_moves = possible_moves

    def evaluate(self):
        opponent = get_opponent(self.iplay)
        score = 0
        for i in range(0, self.n):
            for j in range(0, self.n):
                if self.state[i][j] == self.iplay:
                    score = score+self.values[i][j]
                elif self.state[i][j] == opponent:
                    score = score-self.values[i][j]
        return score

    def run_play(self, player, i, j):
        can_raid = False
        raidcount = 0
        ## Run one step
        self.state[i][j] = player
        n = self.n
        opponent = get_opponent(player)
        for k in range(0, 4):
            row_move = i+ROW_MOVES[k]
            col_move = j+COL_MOVES[k]
            if row_move<0 or row_move>=n or col_move<0 or col_move>=n:
                continue
            if self.state[row_move][col_move] == player:
                can_raid = True
                break
        if can_raid:
            for k in range(0, 4):
                row_move = i+ROW_MOVES[k]
                col_move = j+COL_MOVES[k]
                if row_move<0 or row_move>=n or col_move<0 or col_move>=n:
                    continue
                if self.state[row_move][col_move] == opponent:
                    self.state[row_move][col_move] = player
                    raidcount+=1
        if raidcount:
            return True
        else:
            return False



def main(filepath):
    board = Input(filepath)
    if board.mode == 'MINIMAX':
        opti, optj = MiniMax(board, board.iplay)
        can_raid = board.run_play(board.iplay, opti, optj)
    else:
        opti, optj = AlphaBeta(board, board.iplay)
        can_raid = board.run_play(board.iplay, opti, optj)
    if can_raid:
        moved = 'Raid'
    else:
        moved = 'Stake'
    str_to_write = ''
    str_to_write = '{}{} {}\n'.format(chr(ord('A')+optj), opti+1, moved)
    for i in range(0, board.n):
        for j in range(0, board.n):
            str_to_write+='{}'.format(board.state[i][j])
        str_to_write+='\n'
    with open('output.txt','w') as f:
        f.write(str_to_write[:-1])

    """
    print(board.n)
    print(board.mode)
    print(board.iplay)
    print(board.depth)
    print(board.values)
    print(board.state)
    """



if __name__ == '__main__':
    #main(sys.argv[1])
    main('input.txt')
