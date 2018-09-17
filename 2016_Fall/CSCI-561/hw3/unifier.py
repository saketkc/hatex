import tokrules
import ply.lex as lex
from parser import *
import parser# as myparser
import ply.yacc as yacc
from tokrules import tokens

def unify(x, y, theta=None):
    if not theta:
        return
    elif x is y:
        return theta
    elif isinstance(x, list) and isinstance(y, list):
        if len(x)==1:
            return unify(x[0], y[0], s)
        return unify(x[1:], y[1:], unify(x[0], y[0], s))
    elif x.type == 'predicatevar':
        return unify_var(x, y, theta)
    elif y.type == 'predicatevar':
        return unify_var(y, x, theta)
    elif x.type == 'predicateconst':
        if x.value == y.value:
            return theta
        print ('Failed to unify')
        return
    return

def unify_var(var, x, theta):
    if var in theta.keys():
        return unify(theta[var], x, theta)
    elif x in theta.keys():
        return unify(var, theta[var], theta)
    else:
        theta[var] = x
        return theta

if __name__ == '__main__':
    text  = '((A(x,y) => B(z)) => C(t))'
    lexer = lex.lex(module=tokrules)
    #lexer.input(text)
    parser = yacc.yacc()
    result = parser.parse(text,lexer=lexer)#, debug=True)

    root = Base(parser.parse(text))
    dummy_parent(root)
    move_not_inward(root)
    distribute(root)
    print(text)
    print(result)
    print(root)
