import csv
try:
    import queue as Q
except ImportError:
    import Queue as Q
import sys

class Node(object):
    def __init__(self, cost=0, label=None, parent=None, G=0, H=0):
        self.path_cost = cost
        self.label = label
        self.parent = parent
        self.G = G
        self.H = H

    def get_children(self, graph, distance_mappings):
        children = []
        try:
            ## Child with no nodes ## See bfs.example1.txt
            child = graph[self.label]
        except KeyError:
            return []
        for index, child in enumerate(graph[self.label]):
            children.append(Node(distance_mappings[index], label=child, parent=self))
        return children

    def get_children_ucs(self, graph, distance_mappings):
        children = []
        try:
            ## Child with no nodes ## See bfs.example1.txt
            child = graph[self.label]
        except KeyError:
            return []
        for index, child in enumerate(graph[self.label]):
            children.append(Node(self.path_cost+distance_mappings[index], label=child, parent=self))
        return children


    def get_bfs_children(self, graph):
        children = []
        try:
            ## Child with no nodes ## See bfs.example1.txt
            child = graph[self.label]
        except KeyError:
            return []
        for child in graph[self.label]:
            children.append(Node(self.path_cost+1, label=child, parent=self))
        return children


    def get_children_hueristic(self, graph, distance_mappings, hueristics):
        children = []
        try:
            ## Child with no nodes ## See bfs.example1.txt
            child = graph[self.label]
        except KeyError:
            return []
        for index, child in enumerate(graph[self.label]):
            children.append(Node(distance_mappings[index]+hueristics[child.label], child, self))
        return children


    def traceback(self, astar=False):
        parent = self
        path = []
        path_cost = []
        while parent:
            path.append(parent.label)
            if astar:
                path_cost.append(parent.G)
            else:
                path_cost.append(parent.path_cost)
            parent = parent.parent
        return {'path': list(reversed(path)), 'path_cost': list(reversed(path_cost))}

    def __eq__(self, other):
        # Nodes are equal if labels match
        return self.label == other.label



class InputFile(object):
    def __init__(self, path):
        self.filepath = path
        with open(path, 'r') as f:
            lines = [l.strip() for l in f]
        self.lines = lines
        self._parse()
        self.make_graph()
        self.store_hueristic()
        if self.algo == 'BFS':
            results = self.perform_bfs_dfs_node(bfs=True)
            path = results['path']
            path_cost = results['path_cost']
        elif self.algo == 'DFS':
            results = self.perform_bfs_dfs_node(bfs=False)
            path = results['path']
            path_cost = results['path_cost']
        elif self.algo == 'UCS':
            results = self.perform_ucs_corrected()
            path = results['path']
            path_cost = results['path_cost']
        elif self.algo == 'A*':
            results = self.perform_astar()
            path = results['path']
            path_cost = results['path_cost']
        write_output(path, path_cost)

    def _parse(self):
        lines = self.lines
        self.algo = lines[0]
        self.start_state = lines[1]
        self.goal_state = lines[2]
        self.num_traffic_lines = int(lines[3])
        self.traffic_lines = lines[4:4+self.num_traffic_lines]
        self.num_sunday_traffic_lines = int(lines[4+self.num_traffic_lines])
        self.sunday_traffic_lines = lines[4+self.num_traffic_lines+1:]

    def make_graph(self):
        self.graph = {}
        self.distance_mappings = {}
        for line in self.traffic_lines:
            parent, child, weight = line.split(' ')
            if not parent in self.graph.keys():
                self.graph[parent] = []
                self.distance_mappings[parent] = []
            self.graph[parent].append(child)
            self.distance_mappings[parent].append(int(weight))

    def store_hueristic(self):
        self.hueristics = {}
        for line in self.sunday_traffic_lines:
            key, value = line.split(' ')
            self.hueristics[key] = int(value)

    def perform_bfs_dfs_node(self, bfs=True):
        current_node = Node(label=self.start_state, parent=None, cost = 0)
        ## Goal test
        if current_node.label == self.goal_state:
            return {'path': [self.goal_state], 'path_cost': [0]}
        queue = [current_node]
        explored = []
        while queue:
            curr_node = queue.pop(0)
            if curr_node not in explored:
                explored.append(curr_node)
                children_nodes = curr_node.get_bfs_children(self.graph)
                for node in children_nodes:
                    if node.label == self.goal_state:
                        return node.traceback(astar=False)
                if not bfs:
                    queue = [child for child in children_nodes if child not in explored] + queue
                else:
                    queue.extend([child for child in children_nodes if child not in explored])


    def perform_ucs_corrected(self):
        frontier = Q.PriorityQueue()
        start_node = Node(0, self.start_state, None)
        frontier.put((start_node.path_cost, start_node))
        explored = []
        while not frontier.empty():
            curr_dist, curr_node = frontier.get()
            if curr_node.label == self.goal_state:
                return curr_node.traceback(astar=False)
            explored.append(curr_node.label)
            try:
                children_nodes = curr_node.get_children_ucs(self.graph,
                                                    self.distance_mappings[curr_node.label])
            except KeyError:
                children_nodes = []
            for child in children_nodes:
                if (child.path_cost, child) not in frontier.queue and child.label not in explored:
                    # insert
                    frontier.put((child.path_cost, child))
                else:
                    # find index,
                    index = [i for i,v in enumerate(frontier.queue) if v[1] == child]
                    frontier_element = frontier.queue[index[0]]
                    frontier_child_dist = frontier_element[0]
                    ## change distamce
                    if child.path_cost < frontier_child_dist:
                        new_frontier = Q.PriorityQueue()
                        modified_element = (child.path_cost, Node(child.path_cost, child.label, child.parent))
                        for elem_index,  element in enumerate(frontier.queue):
                            ## Delete element
                            if index[0]!= elem_index:
                                new_frontier.put(element)
                        ## Add element
                        new_frontier.put(modified_element)
                        frontier = new_frontier


    def perform_astar(self):
        frontier = []
        hueristic_scores = self.hueristics
        start_node = Node(0, self.start_state, None, 0, hueristic_scores[self.start_state])
        frontier.append(start_node)
        explored = []
        while frontier:
            curr_node = min(frontier, key=lambda n: n.G+n.H)
            if curr_node.label == self.goal_state:
                return curr_node.traceback(astar=True)
            frontier.remove(curr_node)
            explored.append(curr_node)
            try:
                children_nodes = curr_node.get_children_ucs(self.graph,
                                                    self.distance_mappings[curr_node.label])
            except KeyError:
                children_nodes = []
            for child_index, child in enumerate(children_nodes):
                if child in explored:
                    continue
                if child not in frontier:
                    frontier.append(Node(parent=curr_node,
                                      label=child.label,
                                      G=curr_node.G+self.distance_mappings[curr_node.label][child_index],
                                      H=hueristic_scores[child.label]))
                else:
                    if curr_node.G < child.H:
                        child.G = curr_node.G
                        child.parent = curr_node
                        frontier.append(child)


def read_input(filepath):
    """Read input"""
    InputFile(filepath)

def write_output(path, path_cost):
    with open('output.txt', 'w') as f:
        writer = csv.writer(f, delimiter=' ')
        writer.writerows(zip(path, path_cost))

if __name__ == '__main__':
    read_input(sys.argv[1]) #('input.txt')
    #read_input('input.txt')

