"""
Provided code for Application portion of Module 1

Imports physics citation graph
"""

# general imports

import urllib2
from pylab import *
import matplotlib.pyplot  as pyplot

# Set timeout for CodeSkulptor if necessary
#import codeskulptor
#codeskulptor.set_timeout(20)


###################################
# Code for loading citation graph

CITATION_URL = "http://storage.googleapis.com/codeskulptor-alg/alg_phys-cite.txt"

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

citation_graph = load_graph(CITATION_URL)
idd = in_degree_distribution(citation_graph)
sums = sum(idd.values())
mod_idd = {key: value/sums for key, value in idd.iteritems()}
vals = []
keys = mod_idd.keys()
for key in keys:
    vals.append(mod_idd[key])
fig = pyplot.figure()
ax = fig.add_subplot(2,1,1)
line, = ax.loglog(keys, vals)
print mod_idd
#ax.set_xscale('log')
#ax.set_yscale('log')
show()





