tokens = (
    'NAME','VARIABLE','IMPLY'
    )

literals = ['|','&','~','(',')',',']

# Tokens

def t_NAME(t):
    r'[A-Z][a-zA-Z0-9_]*'
    t.value = str(t.value)
    return t

def t_VARIABLE(t):
    r'[a-z]'
    t.value = str(t.value)
    return t

t_IMPLY = r'=>'

t_ignore = " \t"

def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)
