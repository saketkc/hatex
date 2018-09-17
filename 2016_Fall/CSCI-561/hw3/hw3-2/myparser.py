import ply.yacc as yacc
import ply.lex as lex
from tokrules import tokens
import tokrules
class BaseNode(object):
    def __init__(self):
        self.flag = True
        self.left = None
        self.right = None
        self.op = None
        self.predicate = None
        self.params = None
    def __repr__(self):
        return ('Flag: {}\n Left: {}\n Right: {}\n OP: {}\n Pred:{}\n Params:{}\n').format(str(self.flag), str(self.left), str(self.right), str(self.op), str(self.predicate), str(self.params))

def p_statement(p):
    'statement : expression'
    p[0] = p[1]

def p_expression(p):
    '''expression : simpleexpression
                  | compoundexpression
    '''
    p[0] = p[1]

def p_compoundexpression_group(p):
    '''compoundexpression : LPAREN expression RPAREN
    '''
    p[0] = p[2]

def p_compoundexpression_not(p):
    '''compoundexpression : '~' expression
    '''
    p[2].flag = not p[2].flag
    p[0] = p[2]

def p_compoundexpression_and(p):
    '''compoundexpression : expression '&' expression
    '''
    p[0] = BaseNode()
    p[0].left = p[1]
    p[0].right = p[3]
    p[0].op = 'AND'

def p_compoundexpression_or(p):
    '''compoundexpression : expression '|' expression

    '''
    p[0] = BaseNode()
    p[0].left = p[1]
    p[0].right = p[3]
    p[0].op = 'OR'

def p_compoundexpression_imply(p):
    '''compoundexpression : expression IMPLY expression

    '''
    p[0] = BaseNode()
    p[0].left = p[1]
    p[0].right = p[3]
    p[0].op = 'IMPLY'

def p_predicate(p):
    '''predicate : PREDICATENAME'''
    p[0] = p[1]

def p_simpleexpression(p):
    '''simpleexpression : predicate LPAREN terms RPAREN'''
    p[0] = BaseNode()
    p[0].predicate = p[1]
    p[0].params = p[3]

def p_terms(p):
    '''terms : term
             | term ',' terms
    '''
    p[0] = [p[1]]
    if len(p)>2:
        p[0]+=p[3]

def p_term(p):
    '''term : constant
            | PREDICATEVAR
    '''
    p[0] = p[1]

def p_constant(p):
    '''constant : PREDICATENAME'''
    p[0] = p[1]

# Error rule for syntax errors
def p_error(p):
    print("Syntax error in input!")

def eliminate_implication(root):
    if root.op == 'IMPLY':
        root.left.flag = not root.left.flag
        root.op = 'OR'
    if root.left:
        eliminate_implication(root.left)
    if root.right:
        eliminate_implication(root.right)

def move_not_inward(root):
    if root.left:
        if not root.flag:
            root.flag = True
            if root.op == 'OR':
                root.op = 'AND'
            elif root.op == 'AND':
                root.op = 'OR'
            root.left.flag = not root.left.flag
            root.right.flag = not root.right.flag
        move_not_inward(root.left)
        move_not_inward(root.right)


def distribute(root):
    result = []
    if not root.left:
        result.append(root)
    else:
        if root.op == 'AND':
            result = distribute(root.left) + distribute(root.right)
        elif root.op == 'OR':
            left = distribute(root.left)
            right = distribute(root.right)
            for l in left:
                for r in right:
                    node = BaseNode()
                    node.op = 'OR'
                    node.left = l
                    node.right = r
                    result.append(node)
    return result


def is_predvar(s):
    if len(s)==1:
        return s.islower()
    return False

def convert_to_cnf(text):
    lexer = lex.lex(module=tokrules)
    #lexer.input(text)
    parser = yacc.yacc()
    root = parser.parse(text,lexer=lexer)#, debug=True)

    #root = BaseNode()
    eliminate_implication(root)
    move_not_inward(root)
    root=distribute(root)
    return root#.left.params


if __name__ == '__main__':
    text  = '((A(x,y) ^ B(z)) => C(t))'.replace('^', '&')
    print(text)
    #lexer = lex.lex(module=tokrules)
    #lexer.input(text)
    #parser = yacc.yacc()
    #result = parser.parse(text,lexer=lexer)#, debug=True)
    print(convert_to_cnf(text))
