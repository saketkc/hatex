from ply import lex

tokens = ['PREMISE', 'AND', 'OR', 'IMPLY', 'NOT', 'LPAREN', 'RPAREN']

t_AND = r'\^'
t_OR = r'\|'
t_IMPLY = r'=>'
t_NOT = r'\~'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'

def t_PREMISE(t):
    r'\w+\(.*?\)'
    return t
t_ignore  = ' \t'

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

#def build(self,**kwargs):
#    self.lexer = lex.lex(module=self, **kwargs)

#def test(self, data):
#    self.lexer.input(data)
#    while True:
#         tok = self.lexer.token()
#         if not tok:
#             break
#         print(tok)

if __name__ == '__main__':
    with open('input.txt') as f:
        text = f.read()

    lexer = lex.lex()
    lexer.input(text)

