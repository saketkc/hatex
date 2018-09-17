import tokrules
import ply.lex as lex
from parser import *
import parser# as myparser
import ply.yacc as yacc
from tokrules import tokens
import sys
import itertools
import copy

std_var_counter = itertools.count()

def is_predvar(s):
    if len(s)==1:
        return s.islower()
    return False

def collapse_queries(query, kb_clause, kb_stmt):
    collapsed_query = []
    lookup_table = {}
    for i in range(0, len(query.params)):
        s = query.params[i]
        t = kb_clause.params[i]
        if not is_predvar(s) and is_predvar(t):
            lookup_table[t] = s
    for clause in kb_stmt:
        if clause!=kb_clause:
            new_node = copy.deepcopy(clause)
            for index in range(len(new_node.params)):
                if new_node.params[index] in lookup_table:
                    new_node.params[index] = lookup_table[new_node.params[index]]
            collapsed_query.append(new_node)
    return collapsed_query


def check_over(query, kb_clause):
    if query.predicate == kb_clause.predicate and query.flag!=kb_clause.flag:
        for index, param in enumerate(query.params):
            kb_param = kb_clause.params[index]
            if (not is_predvar(param)) and (not is_predvar(kb_param)):
                if kb_param!=param:
                    return False
        return True
    return False

def ask(KB, lookup_table, history, query):
    if history:
        for item in history:
            if item == query:
                return False
    for kb_stmt_index in lookup_table[query.predicate]:
        for kb_item in KB[kb_stmt_index]:
            if check_over(query, kb_item):
                collapsed_query = collapse_queries(query, kb_item, KB[kb_stmt_index])
                if not collapsed_query:
                    return True
                else:
                    can_unify = True
                    for cq in collapsed_query:
                        newhist = history
                        newhist.append(query)
                        if not ask(KB, lookup_table, newhist, cq):
                            can_unify = False
                            break
                    if can_unify:
                        return True
                break
    return False

def parse_input(input_f):
    query_list = []
    sentence_list = []
    with open(input_f) as fh:
        n_queries = int(fh.readline().strip())
        for i in range(0, n_queries):
            query_list.append(fh.readline().strip().replace(' ','').replace('^', '&'))
        n_sentences = int(fh.readline().strip())
        for i in range(0, n_sentences):
            sentence_list.append(fh.readline().strip().replace(' ','').replace('^', '&'))
    return query_list, sentence_list

class MyKB(object):
    def __init__(self, clauses=[]):
        #self.cnf_clauses = [parser.convert_to_cnf(clause.replace(' ','').replace('^', '&')) for clause in clauses]
        self.cnf_clauses = []
        self.lexer = lex.lex(module=tokrules)
        #lexer.input(text)
        self.myparser = yacc.yacc()
        for clause in clauses:
            cnf = self.convert_to_cnf(clause)
            self.cnf_clauses += cnf
        self.KB = self.tell(self.cnf_clauses)
        self.lookup_table = {}
        self.create_lookup_table()

    def convert_to_cnf(self, text):
        root = self.myparser.parse(text,lexer=self.lexer)#, debug=True)
        eliminate_implication(root)
        move_not_inward(root)
        root = distribute(root)
        return root#.left.params

    def tell(self, clauses):
        KB = []
        for root in clauses:
            KB.append(self.populate_tree(root))
        return KB

    def populate_tree(self, root):
        all_nodes = []
        if not root.left:
            all_nodes.append(root)
        else:
            all_nodes+=self.populate_tree(root.left)
            all_nodes+=self.populate_tree(root.right)
        return all_nodes

    def create_lookup_table(self):
        #print(len(self.KB))
        for index, clauses in enumerate(self.KB):
            for clause in clauses:
                pred = clause.predicate
                if pred not in self.lookup_table:
                    self.lookup_table[pred] = []
                self.lookup_table[pred].append(index)

    def ask(self, queries):
        asked_queries = []
        for clause in queries:
            cnf = self.convert_to_cnf(clause)
            asked_queries += cnf
        self.query_base = asked_queries
        return self.query_base
        #return self.infer_all()

    def get_KB(self):
        return self.KB

    def get_lookup_table(self):
        return self.lookup_table

    def infer_all(self):
        output = ''
        history = []
        for query in self.query_base:
            query.flag = not query.flag
            if self.do_infer(history, query):
                output+='TRUE\n'
            else:
                output+='FALSE\n'
        return output

    def do_infer(self, history, query):
        if history:
            for item in history:
                if item == query:
                    return False
        for kb_stmt_index in self.lookup_table[query.predicate]:
            for item in self.KB[kb_stmt_index]:
                if check_over(query, item):
                    collapsed_query = collapse_queries(query, item, self.KB[kb_stmt_index])
                    if not collapsed_query:
                        return True
                    else:
                        can_unify = True
                        for cq in collapsed_query:
                            newhist = history
                            newhist.append(query)
                            if not self.do_infer(newhist, cq):
                                can_unify = False
                                break
                        if can_unify:
                            return True
                    break
        return False

query_list, sentence_list = parse_input('input1.txt')
kb = MyKB(sentence_list)
KB = kb.get_KB()
lookup_table = kb.get_lookup_table()
queries = kb.ask(query_list)
with open('output.txt', 'w') as f:
    f.write(kb.infer_all())
