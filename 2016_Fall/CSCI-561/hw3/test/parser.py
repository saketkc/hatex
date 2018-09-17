from ply import lex
from ply import yacc
class Tree(object):
    def __init__(self):
        self.relation = None
        self.left = None
        self.right = None
        self.flag = True


precedence = (
        ('left',  'OR'),
        ('left',  'AND'),
        ('right', 'NOT'),
        ('left', 'IMPLY')

)



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


root = Tree()

def eliminate_implicate(root):
    if root.relation == 'IMPLY':
        root.relation = 'OR'
        root.left.flag = not root.left.flag
    if root.left:
        eliminate_implicate(root.left)
    if root.right:
        eliminate_implicate(root.right)


def p_statement(p):
    'statement : expression'
    root = p[1]
    eliminate_implicate(root)
    #move_not_inwards(root)

def p_expression_imply(p):
    '''expression : expression IMPLY premise
                  | premise IMPLY premise
                  | premise IMPLY expression
    '''
    p[0] = '(~'+p[1] + '|' +p[3] + ')'

def p_expression_premise(p):
    'expression : LPAREN expression RPAREN'
    p[0] = p[2]

def p_premise_expr(p):
    'premise : PREMISE'
    p[0] = p[1]

# Error rule for syntax errors
def p_error(p):
    print("Syntax error in input!")

text  = '((A(x,y) => B(z)) => C(t))'
lexer = lex.lex()
lexer.input(text)
while True:
    tok = lexer.token()
    if not tok:
        break
    print(tok)
parser = yacc.yacc()
result = parser.parse(text,lexer=lexer)
print(result)

