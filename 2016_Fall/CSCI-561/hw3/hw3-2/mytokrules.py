import ply.yacc as yacc
import ply.lex as lex
tokens = ('IMPLY', 'PREDICATENAME', 'PREDICATEVAR', 'RPAREN', 'LPAREN')

precedence = (
        ('left', 'IMPLY'),
        ('left', '|', '&'),
        ('right', '~'),
)

t_ignore  = ' \t'
t_IMPLY = r'=>'
t_RPAREN = r'\)'
t_LPAREN = r'\('

literals = ['|', ',', '&',  '~']

class BaseNode(object):
    def __init__(self):
        self.flag = True
        self.left = None
        self.right = None
        self.op = None
        self.predicate = None
        self.params = None


def t_PREDICATENAME(t):
    r'[A-Z][A-Za-z0-9_]*'
    #r'[A-Z][A-Za-z]*\('
    t.value = str(t.value)
    return t

def t_PREDICATEVAR(t):
    r'[a-z]'
    #TODO Check this
    #r'[a-z][a-z0-9_]*'
    t.value = str(t.value)
    return t

"""
def t_PREDICATECONST(t):
    r'[A-Z][a-zA-Z0-9_]*'
    return t
"""

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)



if __name__ == '__main__':
    text  = '((A(x,y) & B(z)) => C(t))'
    print(text)
    lexer = lex.lex()
    root = lexer.input(text)
    while True:
        tok = lexer.token()
        if not tok:
            break      # No more input
        print(tok)
    print(root)
