import sys
import ply.yacc as yacc
import ply.lex as lex


class TreeNode(object):
    def __init__(self):
        self.flag = True
        self.relation = None
        self.left = None
        self.right = None
        self.predicate = None
        self.parameter = None


RELATION = {
    1:'OR',
    2:'AND',
    3:'IMPLY'
}

def printTree(root,layer):
    tmp = " "*layer
    print (tmp+"Flag:"+str(root.flag))
    if root.relation:
        print (tmp+"Relation:"+str(root.relation))
    if root.predicate:
        print (tmp+"Predicate Name:"+str(root.predicate))
    if root.parameter:
        print (tmp+"parameter:"+str(root.parameter))
    if root.left:
        printTree(root.left,layer+1)
    if root.right:
        printTree(root.right,layer+1)

def eliminateImpl(root):
    if root.relation == 'IMPLY':
        root.left.flag = not root.left.flag
        root.relation = RELATION[1]
    if root.left:
        eliminateImpl(root.left)
    if root.right:
        eliminateImpl(root.right)

def moveInward(root):
    if root.left:
        if not root.flag:
            root.flag = True
            if root.relation=='OR':
                root.relation = 'AND'
            elif root.relation=='AND':
                root.relation = 'OR'
            root.left.flag = not root.left.flag
            root.right.flag = not root.right.flag
        moveInward(root.left)
        moveInward(root.right)

def distribute(root):
    result = []
    if not root.left:
        result.append(root)
    else:
        if root.relation == 'AND':
            result = distribute(root.left)+distribute(root.right)
        elif root.relation == 'OR':
            resultLeft = distribute(root.left)
            resultRight = distribute(root.right)
            for leftElement in resultLeft:
                for rightElement in resultRight:
                    tmp = TreeNode()
                    tmp.relation = 'OR'
                    tmp.left = leftElement
                    tmp.right = rightElement
                    result.append(tmp)
    return result





if sys.version_info[0] >= 3:  
    raw_input = input  
  
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
      
lex.lex()  
  
# Parsing rules  
  
precedence = (
    ('left','IMPLY'),  
    ('left','|','&'),   
    ('right','~'),  
    )  
  
# dictionary of names  
names = { }  

kb = []
root = TreeNode()

def p_statement(p):
    'statement : sentence'
    root = p[1]
    #printTree(root,0)
    eliminateImpl(root)
    #printTree(root,0)
    moveInward(root)
    #printTree(root,0)
    global kb
    kb+=distribute(root)
    # for s in kb:
    #     print ("SENTENCE-------------------")
    #     printTree(s,0)

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
        p[0] = TreeNode()
        p[0].left = p[1]
        p[0].right = p[3]
        p[0].relation = RELATION[1]
    elif p[2] == '&':
        p[0] = TreeNode()
        p[0].left = p[1]
        p[0].right = p[3]
        p[0].relation = RELATION[2]
    else:
        p[0] = TreeNode()
        p[0].left = p[1]
        p[0].right = p[3]
        p[0].relation = RELATION[3]

def p_predicate(p):
    "predicate : NAME"
    p[0] = p[1]

def p_atomsentence(p):
    "atomsentence : predicate '(' terms ')'"
    p[0] = TreeNode()
    p[0].predicate = p[1]
    p[0].parameter = p[3]
 

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
   
yacc.yacc()  


read = open("input.txt")
x = int(read.readline())
queries = []
for i in range(x):
    queries.append(read.readline().rstrip('\n'))
print (queries)
y = int(read.readline())
for i in range(y):
    s = read.readline().rstrip('\n')
    yacc.parse(s)
for sentence in kb:
    printTree(sentence,0)
# while 1:  
#     try:  
#         s = raw_input('calc > ')  
#     except EOFError:  
#         break  
#     if not s: continue  
#     yacc.parse(s)  