import ply.yacc as yacc
import ply.lex as lex
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



def eliminate_implication(root):
    if root.op == 'IMPLY':
        root.left.flag = not root.left.flag
        root.op = op[1]
    if root.left:
        eliminate_implication(root.left)
    if root.right:
        eliminate_implication(root.right)

def move_not_inward(root):
    if root.left:
        if not root.flag:
            root.flag = True
            if root.op=='OR':
                root.op = 'AND'
            elif root.op=='AND':
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
            result = distribute(root.left)+distribute(root.right)
        elif root.op == 'OR':
            resultLeft = distribute(root.left)
            resultRight = distribute(root.right)
            for leftElement in resultLeft:
                for rightElement in resultRight:
                    tmp = BaseNode()
                    tmp.op = 'OR'
                    tmp.left = leftElement
                    tmp.right = rightElement
                    result.append(tmp)
    return result

op = {
    1:'OR',
    2:'AND',
    3:'IMPLY'
}

# Parsing rules

precedence = (
    ('left','IMPLY'),
    ('left','|','&'),
    ('right','~'),
    )

# dictionary of names
names = { }

kb = []


def p_statement(p):
    'statement : sentence'
    p[0] = p[1]
    #printTree(root,0)
    #eliminate_implication(root)
    #printTree(root,0)
    #move_not_inward(root)
    #printTree(root,0)
    #global kb
    #kb+=distribute(root)
    #for s in kb:
    #    print ("SENTENCE-------------------")
    #    printTree(s,0)

def p_sentence_assign(p):
    '''sentence : atomsentence
                | complexsentence'''
    p[0] = p[1]

def p_complexsentence(p):
    '''complexsentence : '(' sentence ')'
                  | '~' sentence
                  | sentence '|' sentence
                  | sentence '&' sentence
                  | sentence IMPLY sentence'''
    if p[1] == '(':
        p[0] = p[2]
    elif p[1] == '~':
        p[2].flag= not p[2].flag
        p[0] = p[2]
    elif p[2] == '|':
        p[0] = BaseNode()
        p[0].left = p[1]
        p[0].right = p[3]
        p[0].op = op[1]
    elif p[2] == '&':
        p[0] = BaseNode()
        p[0].left = p[1]
        p[0].right = p[3]
        p[0].op = op[2]
    else:
        p[0] = BaseNode()
        p[0].left = p[1]
        p[0].right = p[3]
        p[0].op = op[3]

def p_predicate(p):
    "predicate : NAME"
    p[0] = p[1]

def p_atomsentence(p):
    "atomsentence : predicate '(' terms ')'"
    p[0] = BaseNode()
    p[0].predicate = p[1]
    p[0].params = p[3]


def p_terms(p):
    '''terms : term
            | term ',' terms'''
    p[0] = []
    p[0].append(p[1])
    if(len(p)>2):
        p[0] += p[3]

def p_term(p):
    '''term : constant
            | VARIABLE'''
    p[0] = p[1]
    # if (p[1][0]>='a' and p[1][0]<='z'):
    #     print ("Variable:"+p[1])
    # else:
    #     print ("CONSTANT:"+p[1])
def p_constant(p):
    "constant : NAME"
    p[0] = p[1]

def p_error(p):
    if p:
        print("Syntax error at '%s'" % p.value)
    else:
        print("Syntax error at EOF")

