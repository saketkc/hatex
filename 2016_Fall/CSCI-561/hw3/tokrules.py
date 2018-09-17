tokens = ('OR', 'AND', 'NOT', 'COMMA',
          'IMPLY', 'PREDICATE',
          'RPAREN', 'LPAREN',
          'PREDICATECONST', 'PREDICATEVAR')

t_ignore  = ' \t'
t_OR = r'\|'
t_AND = r'\^'
t_NOT = r'~'
t_IMPLY = r'=>'
t_COMMA = r','
t_RPAREN = r'\)'
t_LPAREN = r'\('

def t_PREDICATE(t):
    r'[A-Z][A-Za-z]*\('
    return t

def t_PREDICATEVAR(t):
    r'[a-z][a-z0-9_]*'
    return t

def t_PREDICATECONST(t):
    r'[A-Z][a-zA-Z0-9_]*'
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)
