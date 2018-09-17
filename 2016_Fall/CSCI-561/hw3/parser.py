import ply.yacc as yacc
import ply.lex as lex
from tokrules import tokens
import tokrules

precedence = (
        ('left', 'IMPLY'),
        ('left', 'OR'),
        ('left', 'AND'),
        ('right', 'NOT'),
)

class Expr: pass

class Base(Expr):
    def __init__(self, left):
        self.type = 'base'
        self.left = left
        self.right = None
        self.op = 'base'
    def __str__(self):
        return str(self.left)
    def __repr__(self):
        return str(self.left)

class BinOp(Expr):
    def __init__(self,left, op, right, parent=None):
        self.type = 'binop'
        self.left = left
        self.right = right
        self.op = op
        self.parent = parent
    def __str__(self):
        return '{} {} {}'.format(str(self.left), str(self.op), str(self.right))
    def __repr__(self):
        return '{} {} {}'.format(str(self.left), str(self.op), str(self.right))

class Predicate(Expr):
    def __init__(self, name, terms=None):
        self.type = 'predicate'
        self.name = name
        self.terms = []
        if terms:
            self.terms = terms
        self.op = self.type
    def __str__(self):
        return '{}({})'.format(self.name, self.terms)
    def __repr__(self):
        return '{}({})'.format(self.name, self.terms)


class PredicateVariable(Expr):
    def __init__(self, value):
        self.type = 'predicatevar'
        self.value = str(value)
    def __str__(self):
        return str(self.value)
    def __repr__(self):
        return str(self.value)

class PredicateConstant(Expr):
    def __init__(self, value):
        self.type = 'predicateconst'
        self.value = str(value)
    def __str__(self):
        return str(self.value)
    def __repr__(self):
        return str(self.value)

class Negation(Expr):
    def __init__(self, left, parent=None):
        self.type = 'negation'
        self.right = None
        self.left = left
        self.op = '~'
        self.parent = parent
    def __str__(self):
        return '~({})'.format(str(self.left))

class TermList():
    def __init__(self, child):
        self.type = 'list'
        self.terms = []
        self.terms.append(child)
    def __str__(self):
        return ','.join(self.terms)

def p_expression_binop(p):
    '''expression : expression AND expression
                  | expression OR expression
                  | expression IMPLY expression
    '''
    if p[2] == '=>':
        p[0] = BinOp(Negation(p[1]), '|', p[3])
    else:
        p[0] = BinOp(p[1], p[2], p[3])


def p_expression_group(p):
    '''expression : LPAREN expression RPAREN'''
    p[0] = p[2]

def p_expression_atomic(p):
    '''expression : atomic'''
    p[0] = p[1]

def p_not_expression(p):
    '''expression : NOT expression'''
    if p[2].op == '~':
        p[0] = p[2].right
    else:
        p[0] = Negation(p[2])

def p_atomic(p):
    '''atomic : PREDICATE allterms RPAREN'''
    p[0] = Predicate(p[1][:-1])
    p[0].terms = p[2].terms

def p_allterms_term(p):
    '''allterms : term
    '''

    p[0] = TermList(p[1])

def p_allterms_moreterm(p):
    '''allterms : allterms COMMA term'''
    p[1].terms.append(p[3])
    p[0] = p[1]


def p_term_constant(p):
    '''term : PREDICATECONST'''
    p[0] = PredicateConstant(p[1])

def p_term_variable(p):
    '''term : PREDICATEVAR'''
    p[0] = PredicateVariable(p[1])

# Error rule for syntax errors
def p_error(p):
    print("Syntax error in input!")


def move_not_inward(root):
    if root.type == 'predicate':
        return
    if root.op == '~':
        left = root.left
        parent = root.parent
        ## Is nested(double negation)?
        if left.op == '~':
            if parent.left == root:
                parent.left = left.left
            else:
                parent.right = left.left
            left.left.parent = parent
            move_not_inward(left.left)

        if left.op == '|' or left.op == '^':
            left.left = Negation(left.left, left)
            left.right = Negation(left.right, left)
            if left.op == '^':
                left.op = '|'
            elif left.op == '|':
                left.op = '^'
            left.parent = parent
            if parent.left == root:
                parent.left = left
            else:
                parent.right = left
            move_not_inward(left.left)
            move_not_inward(left.right)

    else:
        if root.left:
            move_not_inward(root.left)
        if root.right:
            move_not_inward(root.right)


def dummy_parent(root):
    if root.type == 'predicate':
        return
    if root.left:
        root.left.parent = root
        dummy_parent(root.left)
    if root.right:
        root.right.parent = root
        dummy_parent(root.right)


def distribute(root):
    if root.type == 'predicate':
        return
    if root.left:
        distribute(root.left)
    if root.right:
        distribute(root.right)

    if root.op == '|':
        if not (root.left.op == '^' or root.right.op == '^'):
            return
        left = None
        right = None
        if root.left.op == '^':
            left = BinOp(root.left.left, '|', root.right)
            right = BinOp(root.left.right, '|', root.right)

        elif root.right.op == '^':
            left = BinOp(root.right.left, '|', root.left)
            right = BinOp(root.right.right, '|', root.left)
        statement = BinOp(left, '^', right, root.parent)
        left.parent = statement
        right.parent = statement
        if root.parent.left == root:
            root.parent.left = statement
        else:
            root.parent.right = statement
        distribute(left)
        distribute(right)

def convert_to_cnf(text):
    lexer = lex.lex(module=tokrules)
    #lexer.input(text)
    parser = yacc.yacc()
    result = parser.parse(text,lexer=lexer)#, debug=True)

    root = Base(parser.parse(text))
    dummy_parent(root)
    move_not_inward(root)
    distribute(root)
    return root


if __name__ == '__main__':
    text  = '((A(x,y) ^ B(z)) => C(t))'
    print(text)
    print(convert_to_cnf(text))
