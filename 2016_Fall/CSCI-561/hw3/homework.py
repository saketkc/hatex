import tokrules
import ply.lex as lex
from parser import *
import parser# as myparser
import ply.yacc as yacc
from tokrules import tokens
import sys
import itertools
from unifier import *

CLAUSE_COUNTER = itertools.count()
class VarGenerator(object):
    def __init__(self):
        self.alphabets = tuple('abcdefghijklmnopqrstuvwxyz')
        self.counter = 0
        self.reset_index = 26
        self.name = None
    def generate(self):
        while True:
            name_stack = []
            self.counter +=1
            counter = self.counter
            while counter:
                counter = counter - 1
                name_stack.append(self.alphabets[counter % self.reset_index])
                counter = counter//self.reset_index
            self.name = ('').join(list(name_stack))
            yield self.name

    def __repr__(self):
        return '{}'.format(('').join(self.name))
    def __str__(self):
        return '{}'.format(('').join(self.name))

class ParsePredicate(object):
    def __init__(self, name, args, previous):
        self.head = None
        self.name = name
        self.args = args
        self.previous = previous
        self.next = None

def as_predicate(root, previous):
    if root.type == 'negation':
        ## Predicate is on the previous node
        node = ParsePredicate('~'+root.left.name, root.left.terms, previous)
    else:
        node = ParsePredicate(root.name, root.terms, previous)
    return node

var_generator = VarGenerator()

def split_clause(root):
    clauses = []
    nodes = [root]
    while nodes:
        node = nodes.pop()
        if node.op == '^':
            nodes.append(node.left)
            nodes.append(node.right)
        else:
            clauses.append(node)
    return clauses

def parse_input(input_f):
    query_list = []
    sentence_list = []
    with open(input_f) as fh:
        n_queries = int(fh.readline().strip())
        for i in range(0, n_queries):
            query_list.append(fh.readline().strip().replace(' ','').replace('&', '^'))
        n_sentences = int(fh.readline().strip())
        for i in range(0, n_sentences):
            sentence_list.append(fh.readline().strip().replace(' ','').replace('&', '^'))

    return query_list, sentence_list

def fol_bc_or(KB, goal, theta):
    for rule in KB.fetch_rules_for_goal(goal):
        lhs, rhs = parse_definite_clause(standardize_variables(rule))
        for theta1 in fol_bc_and(KB, lhs, unify(rhs, goal, theta)):
            yield theta1


def fol_bc_and(KB, goals, theta):
    if theta is None:
        pass
    elif not goals:
        yield theta
    else:
        first, rest = goals[0], goals[1:]
        for theta1 in fol_bc_or(KB, subst(theta, first), theta):
            for theta2 in fol_bc_and(KB, rest, theta1):
                yield theta2


def standardize_variables(clause_list, map_name=None):
    if map_name is None:
        map_name = {}
    for clause in clause_list:
        if clause.type == 'binop':
            assert clause.op == '|'
            left = clause.left
            right = clause.right
            if left.op == '~':
                left = left.left
            if right.op == '~':
                right = right.left

            for term in left.terms:
                if term.type == 'predicatevar':
                    if term.value not in map_name:
                        ## Perform substitution
                        #generated_var = var_generator.generate()
                        generated_var = 'v_{}'.format(next(standardize_variables.counter))
                        map_name[term.value] = PredicateVariable(generated_var)
                        term.value = map_name[term.value]
                    else:
                        ## already exists so just replace
                        term.value = map_name[term.value]
            for term in right.terms:
                if term.type == 'predicatevar':
                    if term.value not in map_name:
                        ## Perform substitution
                        #generated_var = var_generator.generate()
                        generated_var = 'v_{}'.format(next(standardize_variables.counter))
                        map_name[term.value] = PredicateVariable(generated_var)
                        term.value = map_name[term.value]
                    else:
                        ## already exists so just replace
                        term.value = map_name[term.value]
        elif clause.type=='predicatevar':
            for term in clause.terms:
                if term.type == 'predicatevar':
                    if term.value not in map_name:
                        ## Perform substitution
                        #generated_var = var_generator.generate()
                        generated_var = 'v_{}'.format(next(standardize_variables.counter))
                        map_name[term.value] = PredicateVariable(generated_var)
                        term.value = map_name[term.value]
                    else:
                        ## already exists so just replace
                        term.value = map_name[term.value]

    return clause_list


standardize_variables.counter = itertools.count()

def get_predicate_names(splitted_clause):
    all_nodes = [splitted_clause]
    names = []
    while all_nodes:
        node = all_nodes.pop()
        if node.op == '|':
            all_nodes.append(node.left)
            all_nodes.append(node.right)
        else:
            names.append(node.name)
    return names

class MyKB(object):
    def __init__(self, clauses=[]):
        self.clauses = [clause for clause in clauses]
        self.cnf_clauses = [convert_to_cnf(clause) for clause in clauses]

    def tell(self, sentence):
        self.clauses.append(sentence)

    def create_lookup_table(self):
        for index, clause in enumerate(self.cnf_clauses):
            splitted_clauses = split_clause(clause.left)




#query_list, sentence_list = parse_input(sys.argv[1])
query_list, sentence_list = parse_input('input.txt')
KB = MyKB(sentence_list)

for line in KB.clauses:
    k_cnf = convert_to_cnf(line)
    ## Split with & and or
    splitted_clauses = split_clause(k_cnf.left)
    lhs, rhs = standardize_variables(splitted_clauses)

"""
with open('output.txt', 'w') as f:
    for line in query_list:
        query_cnf = convert_to_cnf(line)
        query = as_predicate(query_cnf.left, None)
        asked = ask(KB, query)
        if asked:
            f.write('TRUE\n')
        else:
            f.write('FALSE\n')
"""
