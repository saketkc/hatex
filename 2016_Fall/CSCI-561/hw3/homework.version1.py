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
    def generate(self):
        while True:
            name_stack = []
            self.counter +=1
            counter = self.counter
            while counter:
                counter = counter - 1
                name_stack.append(self.alphabets[counter % self.reset_index])
                counter = counter//self.reset_index
            name = ('').join(list(name_stack))
            yield name

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

def as_predicate(root, previous):
    if root.type == 'negation':
        ## Predicate is on the previous node
        node = ParsePredicate('~'+root.left.name, root.left.terms, previous)
    else:
        node = ParsePredicate(root.name, root.terms, previous)
    return node


class SentenceClause(object):
    def __init__(self):
        self.next = None
        self.count = next(CLAUSE_COUNTER)

    def __repr__(self):
        return 'Clause: {}'.format(self.count)

    def create_copy(self, predicate=None):
        clause = SentenceClause()
        current_clause = clause
        originating_clause = self.next
        while originating_clause:
            temp_clause = current_clause
            current_clause = originating_clause.create_copy()
            if originating_clause is predicate:
                predicate = current_clause

            current_clause.previous = temp_clause
            current_clause.head = clause
            temp_clause.next = current_clause
            originating_clause = originating_clause.next
        if predicate:
            return clause, predicate
        else:
            return clause

def list_of_clauses(root_clause):
    head = SentenceClause()
    curr_node = head
    all_nodes = [root_clause]
    while all_nodes:
        node = all_nodes.pop()
        if node.op == '|':
            all_nodes.append(node.left)
            all_nodes.append(node.right)
        else:
            temp_node = curr_node
            curr_node = as_predicate(node, temp_node)
            curr_node.head = head
            temp_node.next = curr_node
    return head



def tell(kb, line):
    root = convert_to_cnf(line)
    #print(line)
    #print(root)
    splitted_clauses = split_clause(root.left)
    #print(splitted_clauses)
    for clause in splitted_clauses:
        clause_list = list_of_clauses(clause)
        current_clause = clause_list.next
        while current_clause:
            if current_clause.name not in kb:
                kb[current_clause.name] = []
            kb[current_clause.name].append(current_clause)
            current_clause = current_clause.next
    return kb




def perform_standardization_in_clause(clause, new_var, subst_map):
    node = clause.next
    while node:
        perform_standardization_in_predicate(node, new_var, subst_map)
        node = node.next

def perform_standardization_in_predicate(predicate, new_var, subst_map):
    pred_args = predicate.args
    for pred_arg in pred_args:
        if pred_arg.type == 'predicatevar':
            if pred_arg.value not in subst_map:
                subst_map[pred_arg.value] = pred_arg
                pred_arg.value = next(new_var)
            else:
                pred_arg = subst_map[pred_arg.value]


def perform_substitution(subst_map, clause):
    current_clause = clause.next
    while current_clause:
        args = current_clause.args
        for i in range(len(args)):
            if args[i] in subst_map:
                args[i] = subst_map[args[i]]
        current_clause = current_clause.next


def perform_resolution_ct(should_unify, should_resolve, query, generated_var):
    perform_standardization_in_clause(should_resolve, generated_var, {})
    print(should_resolve)
    subst_map = unify(should_unify.args, query.args, {})
    should_unify.pop_self()
    perform_substitution(subst_map, should_resolve)
    return subst_map


depth_count = itertools.count()

standardize_variables_counter = itertools.count()

def perform_resolution(kb, clause):
    current_count = next(depth_count)
    if current_count>200:
        return False
    next_clause = clause.next
    if not next_clause:
        return True
    negated_term = perform_negation(next_clause.name)
    if negated_term not in kb:
        return False
    else:
        print('cont')
    can_resolve = False
    for predicate in kb[negated_term]:
        if unify(current_clause.args, predicate.args, {}) is None:
            continue
        can_resolve = True
        clause_copy, term_copy = clause.create_copy(next_clause)
        should_resolve, should_unify = predicate.head.create_copy(predicate)
        generated_var = var_generator.generate()

        perform_standardization(clause_copy, generated_var, {})
        subst_map = perform_resolution_ct(should_unify, should_resolve, term_copy, generated_var)
        term_copy.pop_self()
        perform_substitution(subst_map, clause_copy)
        clause_copy.merge(should_resolve)
        if perform_resolution(kn, clause_copy):
            return True
    if not can_resolve:
        return False


def perform_negation(predicate):
    if predicate[0] == '~':
        return predicate[1:]
    return '~' + predicate


class ParsePredicate(object):
    def __init__(self, name, args, previous):
        self.head = None
        self.name = name
        self.args = args
        self.previous = previous
        self.next = None

    def create_copy(self):
        copied_args = []
        for args in self.args:
            if args.type == 'predicatevar':
                copied_args.append(copy.deepcopy(args))
            else:
                copied_args.append(args)
        return ParsePredicate(self.name, copied_args, None)

    def pop_self(self):
        self.previous.next = self.next
        if self.next:
            self.next.previous = self.previous

    def __repr__(self):
        args = ''
        for arg in self.args:
            args = args+ ' ' +str(arg)
        return '[{}: {}]'.format(self.name, arg)

def print_clause_debug(head):
    print(head)
    head= head.next
    while head:
        print(head)
        print('-->')
        head = head.next

def print_KB(kb):
    for k,v in kb.items():
        print('PREDICATE: {}'.format(k))
        for predicate in v:
            print_clause_debug(predicate.head)

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

def ask(kb, query):
    if query.name not in kb:
        return False
    for predicate in kb[query.name]:
        print('Predicate:{}'.format(predicate))
        query_args = query.args
        if unify(query_args, predicate.args, {}) is None:
            continue
        should_resolve, should_unify = predicate.head.create_copy(predicate)
        print(should_resolve)
        generated_var = var_generator.generate()
        perform_resolution_ct(should_unify, should_resolve, query, generated_var)
        if should_resolve.next is None:
            return True
        elif perform_resolution(kb, should_resolve):
            return True
    return False

#query_list, sentence_list = parse_input(sys.argv[1])
KB = {}
query_list, sentence_list = parse_input('input.txt')
for line in sentence_list:
    KB=tell(KB, line)
#print_KB(KB)
with open('output.txt', 'w') as f:
    for line in query_list:
        query_cnf = convert_to_cnf(line)
        query = as_predicate(query_cnf.left, None)
        asked = ask(KB, query)
        if asked:
            f.write('TRUE\n')
        else:
            f.write('FALSE\n')

