#!/usr/bin/env python
"""
Assignment 1

"""
EX_GRAPH0 = {0: set([1, 2]), 1: set([]), 2: set([])}
EX_GRAPH1 = {0: set([1, 4, 5]), 1: set([2, 6]), 2: set([3]),
             3: set([0]), 4: set([1]), 5: set([2]), 6: set([])}
EX_GRAPH2 = {0: set([1, 4, 5]), 1: set([2, 6]), 2: set([3, 7]), 3: set([7]),
             4: set([1]), 5: set([2]), 6: set([]), 7: set([3]), 8: set([1, 2]),
             9: set([0, 3, 4, 5, 6, 7])}


def make_complete_graph(num_nodes):
    """Makes complete graph with num_nodes
    """
    if num_nodes <= 0:
        return  {}
    if num_nodes == 1:
        return {0: set([])}
    dicts = {}
    for key1 in range(0, num_nodes):
        for key2 in range(0, num_nodes):
            if key1!=key2:
                if key1 not in dicts.keys():
                    dicts[key1] = set()
                dicts[key1].add(key2)
    return dicts


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
