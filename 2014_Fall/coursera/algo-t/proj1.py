"""
Provided code for Application portion of Module 1

Imports physics citation graph
"""

# general imports

import urllib2
from pylab import *
import matplotlib.pyplot  as pyplot
#from itertools import izip
# Set timeout for CodeSkulptor if necessary
#import codeskulptor
#codeskulptor.set_timeout(20)
import random

###################################
# Code for loading citation graph

class DPATrial:
    """
    Simple class to encapsulate optimized trials for DPA algorithm

    Maintains a list of node numbers with multiple instances of each number.
    The number of instances of each node number are
    in the same proportion as the desired probabilities

    Uses random.choice() to select a node number from this list for each trial.
    """

    def __init__(self, num_nodes):
        """
        Initialize a DPATrial object corresponding to a
        complete graph with num_nodes nodes

        Note the initial list of node numbers has num_nodes copies of
        each node number
        """
        self._num_nodes = num_nodes
        self._node_numbers = [node for node in range(num_nodes) for dummy_idx in range(num_nodes)]


    def run_trial(self, num_nodes):
        """
        Conduct num_node trials using by applying random.choice()
        to the list of node numbers

        Updates the list of node numbers so that the number of instances of
        each node number is in the same ratio as the desired probabilities

        Returns:
        Set of nodes
        """

        # compute the neighbors for the newly-created node
        new_node_neighbors = set()
        for dummy_idx in range(num_nodes):
            new_node_neighbors.add(random.choice(self._node_numbers))

        # update the list of node numbers so that each node number
        # appears in the correct ratio
        self._node_numbers.append(self._num_nodes)
        self._node_numbers.extend(list(new_node_neighbors))

        #update the number of nodes
        self._num_nodes += 1
        return new_node_neighbors

def generate_complete_graph(n):
    g = {}
    for node in xrange(n):
        g[node] = [item for item in xrange(n) if item != node]
    return g
def compute_in_degrees(digraph):
    """
    Makes a directed graph digraph (represented as a dictionary)
    and computes the in-degrees for the nodes in the graph
    """
    nodes = digraph.keys()
    counts = {x:0 for x in nodes}
    for key in digraph.keys():
        values = digraph[key]
        for value in values:
            counts[value] += 1
    return counts

def in_degree_distribution(digraph):
    """
    Takes a directed graph digraph (represented as a dictionary)
    and computes the unnormalized distribution of the in-degrees of the graph
    """
    frequencies = {}
    in_degrees = compute_in_degrees(digraph)
    for freq in in_degrees.itervalues():
        frequencies[freq] = frequencies.get(freq, 0) + 1
    return frequencies
gg = generate_complete_graph(28000)
dpa = DPATrial(28000)
#nodes = dpa.run_trial(14)
#print nodes
for node in xrange(28000, 14):
    choosing_nodes = dpa.run_trial(14)
    gg[node] = list(choosing_nodes)
idd = in_degree_distribution(gg)
sums = sum(idd.values())
print "sume", sums
mod_idd = {key: float(idd[key])  /sums for key in idd.keys()}
print
print mod_idd
vals = []
keys = mod_idd.keys()
for key in keys:
    vals.append(mod_idd[key])
pyplot.loglog(keys, vals)
pyplot.xlabel("log(in degree)")
pyplot.ylabel("log(frequency)")
pyplot.title("log(in degree) v/s log(frequency) for ER")
pyplot.show()

CITATION_URL = "http://storage.googleapis.com/codeskulptor-alg/alg_phys-cite.txt"


def load_graph(graph_url):
    """
    Function that loads a graph given the URL
    for a text representation of the graph

    Returns a dictionary that models a graph
    """
    graph_file = urllib2.urlopen(graph_url)
    graph_text = graph_file.read()
    graph_lines = graph_text.split('\n')
    graph_lines = graph_lines[ : -1]

    print "Loaded graph with", len(graph_lines), "nodes"

    answer_graph = {}
    for line in graph_lines:
        neighbors = line.split(' ')
        node = int(neighbors[0])
        answer_graph[node] = set([])
        for neighbor in neighbors[1 : -1]:
            answer_graph[node].add(int(neighbor))

    return answer_graph

def random_graph(n,p):
    v = [x for x in range(0,n)]
    e = []
    graph = {}
    for i,k in zip(v[0::2], v[1::2]):
        #print i,k
        a = random.random()
        if a < p:
            if i not in  graph.keys():
                graph[i]=[]
            if k not in graph.keys():
                graph[k]=[]
            graph[i].append(k)
            graph[k].append(i)
            #e.append((i,k))
            #e.append((k,i))
    idd = in_degree_distribution(graph)
    print graph
    print idd
    sums = sum(idd.values())
    print "sume", sums
    mod_idd = {key: float(idd[key])  /sums for key in idd.keys()}
    print
    print mod_idd
    vals = []
    keys = mod_idd.keys()
    for key in keys:
        vals.append(mod_idd[key])
    pyplot.loglog(keys, vals)
    pyplot.xlabel("log(in degree)")
    pyplot.ylabel("log(frequency)")
    pyplot.title("log(in degree) v/s log(frequency) for ER")
    pyplot.show()

#random_graph(10000,0.3)
"""
citation_graph = load_graph(CITATION_URL)
idd = in_degree_distribution(citation_graph)
#print idd
sums = sum(idd.values())
print "sume", sums
mod_idd = {key: float(idd[key])  /sums for key in idd.keys()}
print
print mod_idd
vals = []
keys = mod_idd.keys()
for key in keys:
    vals.append(mod_idd[key])
pyplot.loglog(keys, vals)
pyplot.xlabel("log(in degree)")
pyplot.ylabel("log(frequency)")
pyplot.title("log(in degree) v/s log(frequency)")
pyplot.show()
"""
