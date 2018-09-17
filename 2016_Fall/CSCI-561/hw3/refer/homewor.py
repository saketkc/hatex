#!/bin/python
import pprint
import copy
OPERATORS = ['~', '|', '&', '=>']

test1 = '(DYlaN(x, y) => (~HoMe(y)))'
test2 = '((B(x, y) & B(y, z)) => A(x))'
test3 = '((Bob(x, Y, z) => Kujin(A)) => C(D))'
test4 = '(~(A(x)&(~B(y))))'
test5 = '((~Asd(x)) | (Bww(x)|(Cx(x)&Dy(x))))'
test6 = '((~Asd(x)) | ((Cx(x)&Dy(x))|B(x)))'
test7 = '((A(x)&B(x))|(C(x)&D(x)))'

#Parse predicates and delete parenthesis of predicates
def get_predicates(sentence):
    sentence = ''.join(sentence.split())
    predicates = []
    i = 0
    while i < len(sentence):
        if sentence[i].isupper():
            for j in range((i+1), len(sentence)):
                if sentence[j] == '(':
                    predicate_name = sentence[i:j]
                    l_parent = j
                if sentence[j] == ')':
                    arguments = sentence[(l_parent + 1):j].split(',')
                    i = j
                    break
            predicates.append((predicate_name, True, arguments))
        i += 1
    for predicate_name, indicator, predicate_arguments in predicates:
        sentence = sentence.replace(predicate_name + '(' + ','.join(predicate_arguments) + ')', predicate_name, 1)
    return predicates, sentence

 
def parent_parsing(sentence):
    sentence = ''.join(sentence.split())
    #print sentence
    parent_num = sentence.count('(')
    parent_pos = [0] * parent_num
    parent_pair = [0] * parent_num
    parent_priority = [0] * parent_num
    parent = []
    priority = 1
    lparent_now = 0
    for i in range(len(sentence)):
        if sentence[i] == '(':
            parent_pos[lparent_now] = i
            parent_priority[lparent_now] = priority
            priority += 1
            parent.append(lparent_now)
            lparent_now += 1
        if sentence[i] == ')':
            parent_pair[parent[-1]] = i 
            parent.pop()
            priority -= 1
    '''
    print parent_pos
    print parent_pair
    print parent_priority
    '''
    parent_pairs = dict()
    for left, right in zip(parent_pos, parent_pair):
        parent_pairs[left] = right
        parent_pairs[right] = left
    return parent_pairs

#Change => to ~ and |
def parse_implication(sentence):
    predicates, sentence = get_predicates(sentence) 
    #print sentence
    while(sentence.count('=') > 0):
        parent_pairs = parent_parsing(sentence)
        implication_pos = sentence.index('=')
        sentence_rep = sentence
        if sentence[implication_pos - 1] == ')':
            sentence_rep = sentence_rep[:parent_pairs[implication_pos - 1]] + '(~' + \
sentence_rep[parent_pairs[implication_pos - 1]: implication_pos] + ')' + \
sentence_rep[implication_pos:]
        else:
            i = implication_pos - 1
            while(sentence[i] != '('):
                i -= 1
            i += 1
            sentence_rep = sentence_rep[:i] + '(~' + \
sentence_rep[i: implication_pos] + ')' + \
sentence_rep[implication_pos:]
        sentence = sentence_rep.replace('=>', '|', 1)
    return predicates, sentence
        


#Paring negation
def parse_negation(sentence):
    predicates, sentence = parse_implication(sentence)
    while(sentence.count('~(') > 0):
        if(sentence.count('(~(~') > 0):
            parent_pairs = parent_parsing(sentence)
            negation_pos = sentence.index('(~(~') 
            sentence = sentence[:negation_pos] + sentence[(negation_pos+4):parent_pairs[negation_pos+2]] + sentence[(parent_pairs[negation_pos]+1):]
        else: 
            parent_pairs = parent_parsing(sentence)
            negation_pos = sentence.index('~(')
            sentence_rep = sentence[:negation_pos-1] + '('
            i = negation_pos + 2
            while(i < parent_pairs[negation_pos+1]):
                if sentence[i].isupper():
                    sentence_rep += '(~'
                    sentence_rep += sentence[i]
                    i += 1
                    while(sentence[i].islower()):
                        sentence_rep += sentence[i]
                        i += 1
                    sentence_rep += ')'
                elif sentence[i] == '(': 
                    sentence_rep += '(~'
                    sentence_rep += sentence[i:(parent_pairs[i]+1)]
                    sentence_rep += ')'
                    i = parent_pairs[i] + 1
                elif sentence[i] == '&':
                    sentence_rep += '|'
                    i += 1
                elif sentence[i] == '|':
                    sentence_rep += '&'
                    i += 1
            sentence_rep += sentence[parent_pairs[negation_pos-1]:]
            sentence = sentence_rep
    return predicates, sentence
 
     
def remove_negation(sentence):
    predicates, sentence = parse_negation(sentence)
    while(sentence.count('(~')>0):
        negation_pos = sentence.index('(~')
        parent_pairs = parent_parsing(sentence)
        sentence = sentence[:negation_pos] + sentence[(negation_pos+2):parent_pairs[negation_pos]] + sentence[(parent_pairs[negation_pos]+1):]
    return predicates, sentence
        
def find_operends(sentence, pos):
    parent_pairs = parent_parsing(sentence)
    right_parent = 0
    left_parent = 0
    for i in range(pos+1, len(sentence)):
        if sentence[i] == '(':
            left_parent += 1
        elif sentence[i] == ')':
            right_parent += 1
        if (right_parent - left_parent) == 1:
            break
    left_term = sentence[(parent_pairs[i]+1):pos]
    right_term = sentence[(pos+1):i]
    return [left_term, right_term, parent_pairs[i], i]

def predicates_back(predicates, sentence):
    predicate = predicates[0]
    
    sentence_rep = sentence[:sentence.index(predicate[0])] + predicate[0] + '(' + ','.join(predicate[2]) + ')'
    sentence = sentence[(sentence.index(predicate[0])+len(predicate[0])):]
    for i in range(1, len(predicates)):
        predicate = predicates[i]
        sentence_rep = sentence_rep + sentence[:sentence.index(predicate[0])] + predicate[0] + '(' + ','.join(predicate[2]) + ')'
        sentence = sentence[(sentence.index(predicate[0])+len(predicate[0])):]
    sentence_rep += sentence
    return sentence_rep
    
def distribute(sentence):
    #predicates, sentence = remove_negation(sentence)
    predicates, sentence = parse_negation(sentence)
    sentence = predicates_back(predicates, sentence)
    final = False
    while(not final):
        action = False
        parent_pairs = parent_parsing(sentence)
        or_pos = []
        or_priority = []
        and_pos = []           
        and_priority = []
        left_parent = 0
        right_parent = 0
        for i in range(len(sentence)):
            if (sentence[i] == '('):
                left_parent += 1
            elif (sentence[i] == ')'):
                right_parent += 1
            elif (sentence[i] == '&'):
                and_pos.append(i)
                and_priority.append(left_parent-right_parent)
            elif (sentence[i] == '|'):
                or_pos.append(i)
                or_priority.append(left_parent-right_parent)
        #print and_pos
        #print and_priority
        #print or_pos
        #print or_priority
        for i in range(len(and_priority)):
            for j in range(len(or_priority)):
                or_left_term, or_right_term, or_left_parent, or_right_parent = find_operends(sentence, or_pos[j])
                if ((and_priority[i]-or_priority[j])==1) and (and_pos[i]>or_left_parent) and (and_pos[i]<or_right_parent):
                    and_left_term, and_right_term, and_left_parent, and_right_parent = find_operends(sentence, and_pos[i])
                    if and_pos[i] < or_pos[j]: 
                        sentence = sentence[:(or_left_parent+1)] + '(' + and_left_term + '|' + or_right_term + ')'  \
    + '&' + '(' + and_right_term + '|' + or_right_term + ')' + sentence[or_right_parent:]
                    elif and_pos[i] > or_pos[j]:
                        sentence = sentence[:(or_left_parent+1)] + '(' + or_left_term + '|' + and_left_term + ')'  \
    + '&' + '(' + or_left_term + '|' + and_right_term + ')' + sentence[or_right_parent:]
                    action = True
                if action:
                    break
            if action:
                break
        if not action:
            final = True
    return sentence

def parse_CNF(CNF):
    literals = CNF.split('|')
    predicates = []
    for literal in literals:
        indicator = True
        i = 0
        while(i<len(literal)):
            if literal[i] == '~':
                indicator = False
                i += 1
            elif literal[i].isupper():
                predicate_name = literal[i]
                i += 1
                while(literal[i] != '('):
                    predicate_name += literal[i]
                    i += 1
                i += 1
                argument = ''
                while(literal[i] != ')'):
                    argument += literal[i]
                    i += 1
            else:
                i += 1
        predicates.append([predicate_name, indicator, argument.split(',')])
    return predicates
        
def get_CNF(sentence):
    sentence = distribute(sentence)
    CNF_list = sentence.split('&')
    CNFs = []
    for CNF in CNF_list:
        CNFs.append(parse_CNF(CNF))
    return CNFs

def standardize_name(CNF):
    one_CNF = []
    variable_dict = dict()
    variable_num = 0
    for predicate_name, indicator, arguments in CNF:
        for i in range(len(arguments)):
            if arguments[i][0].islower():
                if arguments[i] in variable_dict.keys():
                    arguments[i] = variable_dict[arguments[i]]
                else:
                    variable_num += 1
                    variable_dict[arguments[i]] = 'v' + str(variable_num)
                    arguments[i] = 'v' + str(variable_num)
        one_CNF.append([predicate_name, indicator, arguments])
    one_CNF.sort()
    return one_CNF

def parse_input(filename):
    with open(filename) as f:
        lines = f.readlines()
    query_num = int(lines[0].strip())
    queries = lines[1:(query_num+1)]
    query_kb = []
    for query in queries:
        indicator = True
        if query.startswith('~'):
            indicator = False
            query = query[1:]
        left_parent = query.index('(')
        right_parent = query.index(')')
        name = query[:left_parent]
        arguments = query[(left_parent+1):right_parent].split(',')
        query_kb.append([[name, indicator, arguments]])
    sentence_num = int(lines[query_num+1].strip())
    sentences = lines[(query_num+2):]
    KB = []
    #variable_num = 0 
    for sentence in sentences:
        sentence = sentence.strip()
        #print sentence
        #print sentence
        #print distribute(sentence) 
        #print get_CNF(sentence)
        for CNF in get_CNF(sentence):
            one_CNF = standardize_name(CNF)
            KB.append(one_CNF)
            #print one_CNF
            
        #print 
    
    #for kb in KB:
       #print kb
    return query_kb, KB

def substitute(arguments1, arguments2):
    assert len(arguments1) == len(arguments2)
    substitute_variable_dict = dict()
    substitute_value_dict = dict()
    for i in range(len(arguments1)):
        term1 = arguments1[i]
        term2 = arguments2[i]
        if term1[0].isupper() and term2[0].isupper() and term1 != term2:
            return False, {}, {}
        elif term1[0].islower() and term2[0].islower():
            if (not term1 in substitute_variable_dict.keys()) and (not term2 in substitute_variable_dict.keys()):
                substitute_variable_dict[term1] = set([term2])
                substitute_variable_dict[term2] = set([term1])
            elif (not term1 in substitute_variable_dict.keys()) and (term2 in substitute_variable_dict.keys()):
                substitute_variable_dict[term1] = set([term2])
                for term in substitute_variable_dict[term2]:
		    substitute_variable_dict[term].add(term1)
                    substitute_variable_dict[term1].add(term)
                substitute_variable_dict[term2].add(term1)
            elif (term1 in substitute_variable_dict.keys()) and (not term2 in substitute_variable_dict.keys()):
                substitute_variable_dict[term2] = set([term1])
                for term in substitute_variable_dict[term1]:
                    substitute_variable_dict[term].add(term2)
                    substitute_variable_dict[term2].add(term)
                substitute_variable_dict[term1].add(term2)
            elif (term1 in substitute_variable_dict.keys()) and (term2 in substitute_variable_dict.keys()):
                for term in substitute_variable_dict[term1]:
                    substitute_variable_dict[term].add(term2)
                for term in substitute_variable_dict[term2]:
                    substitute_variable_dict[term].add(term1)
                substitute_variable_dict[term1].add(term2)
                substitute_variable_dict[term2].add(term1)
    for i in range(len(arguments1)):
        term1 = arguments1[i]
        term2 = arguments2[i]
        if term1[0].isupper() and term2[0].islower():
            if term2 in substitute_value_dict.keys():
                if term1 != substitute_value_dict[term2]:
                    return False, {}, {}
            else:
                substitute_value_dict[term2] = term1
                if term2 in substitute_variable_dict.keys():
                    for term in substitute_variable_dict[term2]:
                        substitute_value_dict[term] = term1
        if term2[0].isupper() and term1[0].islower():
            if term1 in substitute_value_dict.keys():
                if term2 != substitute_value_dict[term1]:
                    return False, {}, {}
            else:
                substitute_value_dict[term1] = term2
                if term1 in substitute_variable_dict.keys():
                    for term in substitute_variable_dict[term1]:
                        substitute_value_dict[term] = term2

    for i in substitute_value_dict.keys():    
        if i in substitute_variable_dict.keys():
            del substitute_variable_dict[i]

    new_substitute_variable_dict = dict()

    for i in substitute_variable_dict.keys():
        for term in substitute_variable_dict[i]:
            if (not term in new_substitute_variable_dict.keys()) and (not term in new_substitute_variable_dict.values()):
                new_substitute_variable_dict[term] = i
    return True, new_substitute_variable_dict, substitute_value_dict
                
def change_name(kb, prefix):
    new_kb = []
    for name, indicator, arguments in kb:
        new_horn = [name, indicator, []]
        for argument in arguments:
            if argument[0].islower():
                new_horn[2].append(prefix + argument)
            else:
                new_horn[2].append(argument)
        new_kb.append(new_horn)
    return new_kb 

def make_new_kb(kb1, kb2, i, j, substitute_variable_dict, substitute_value_dict):
    new_kb = []
    for a in range(len(kb1)):
        if(a!=i):
            predicate_name, indicator, arguments = kb1[a]
            new_arguments = []
            for term in arguments:
                if term.isupper():
                    new_arguments.append(term)
                else:
                    if term in substitute_value_dict.keys():
                        new_arguments.append(substitute_value_dict[term])
                    else:
                        if term in substitute_variable_dict.keys():
                            new_arguments.append(substitute_variable_dict[term])
                        else:
                            new_arguments.append(term)
            new_kb.append([predicate_name, indicator, copy.deepcopy(new_arguments)])

    for a in range(len(kb2)):
        if(a!=j):
            predicate_name, indicator, arguments = kb2[a]
            new_arguments = []
            for term in arguments:
                if term.isupper():
                    new_arguments.append(term)
                else:
                    if term in substitute_value_dict.keys():
                        new_arguments.append(substitute_value_dict[term])
                    else:
                        if term in substitute_variable_dict.keys():
                            new_arguments.append(substitute_variable_dict[term])
                        else:
                            new_arguments.append(term)
            new_kb.append([predicate_name, indicator, copy.deepcopy(new_arguments)])
    return standardize_name(new_kb)

                          
            
            

def unify(kb1, kb2):
    new_kb1 = change_name(kb1, 'a')
    new_kb2 = change_name(kb2, 'b')
    new_kb_list = []
    for i in range(len(new_kb1)):
        for j in range(len(new_kb2)):
            if new_kb1[i][0] == new_kb2[j][0] and new_kb1[i][1] != new_kb2[j][1]:
                indicator, substitute_variable_dict, substitute_value_dict = substitute(new_kb1[i][2], new_kb2[j][2])
                if indicator:
                    new_kb = make_new_kb(new_kb1, new_kb2, i, j, substitute_variable_dict, substitute_value_dict) 
                    #if (len(new_kb) <= len(new_kb1) or len(new_kb) <= len(new_kb2)):
                    if len(new_kb1) == 1 or len(new_kb2) == 1:
                        new_kb_list.append(new_kb)
                #print new_kb

    return new_kb_list

def refresh_KB(KB):
    #pprint.pprint(KB)
    for i in range(len(KB)):
        for j in range(i+1, len(KB)):
            new_kb_list = unify(KB[i], KB[j])
            if new_kb_list:
                for new_kb in new_kb_list:
                    if not new_kb in KB:
                        return refresh_KB(KB+[new_kb])
    return KB 

def ckeck_contradication(KB, new_kb):
    for old_kb in KB:
        if len(old_kb) == 1 and len(new_kb) == 1 and old_kb[0][0] == new_kb[0][0] and old_kb[0][1] != new_kb[0][1]:
            indicator, substitute_variable_dict, substitute_value_dict = substitute(old_kb[0][2], new_kb[0][2])
            if indicator:
                #print old_kb
                #print new_kb
                return True
    return False 
    
def inference(KB, query):
    negation_query = query
    negation_query[0][1] = not query[0][1] 
    new_kb_list = [negation_query]
    while new_kb_list != []:
        new_kb = new_kb_list[0]
        if ckeck_contradication(KB, new_kb):
            return True
        if not new_kb in KB:
            for i in range(len(KB)):
                new_kb_list += unify(KB[i], new_kb)
            KB.append(new_kb)
        new_kb_list = new_kb_list[1:]
    return False
 
if __name__ == '__main__':
    #print parent_parsing(test2)
    #predicates, sentence = get_predicates(test2)
    #print parse_implication(test1)
    #parse_negation(test4)
    #print distribute(test6)
    #print get_CNF(test7)
    query_kb, KB = parse_input('input5.txt')
    final_KB = refresh_KB(KB)
    
    #pprint.pprint(final_KB)
    #pprint.pprint(final_KB)
    #print 
    with open('output.txt', 'wt') as f:
        for query in query_kb:
            f.write(str(inference(final_KB, query)).upper() + '\n')
    '''
    indicator, variable, value = substitute(['x1', 'x2', 'x4', 'x6', 'x1'], ['x2', 'x3', 'x5', 'x5', 'x7']) 
    #indicator, variable, value = substitute(['x1', 'John', 'x1'], ['y2', 'y2', 'John']) 
    
    print indicator
    pprint.pprint(variable) 
    pprint.pprint(value)
    '''
