tokens = ('IMPLY', 'LPAREN', 'RPAREN', 'PREDICATENAME', 'PREDICATEVAR')
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

def t_PREDICATENAME(t):
    r'[A-Z][a-zA-Z0-9_]*'
    t.value = str(t.value)
    return t

def t_PREDICATEVAR(t):
    r'[a-z]'
    t.value = str(t.value)
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)
