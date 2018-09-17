#import pprint
import csv
import pprint
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
        #pp = pprint.PrettyPrinter(indent=4)
        if self.algo == 'BFS':
            results = self.perform_bfs_dfs_node(bfs=True)
            path = results['path']
            path_cost = results['path_cost']
        elif self.algo == 'DFS':
            results = self.perform_bfs_dfs_node(bfs=False)
            path = results['path']
            path_cost = results['path_cost']
        elif self.algo == 'UCS':
            results = self.perform_ucs()
            path = results['path']
            path_cost = results['path_cost']
        elif self.algo == 'A*':
            results = self.perform_astar()
            print results
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

        """
        pp = pprint.PrettyPrinter()
        pp.pprint(self.graph)
        ## Not required since no alphabetic sorting required

        for key in self.graph.keys():
            child_nodes = self.graph[key]
            child_distances = self.distance_mappings[key]
            child_nodes, child_distances = [list(x) for x in zip(*sorted(zip(child_nodes, child_distances),
                                                                         key=itemgetter(0)))]
            self.graph[key] = child_nodes
            self.distance_mappings[key] = child_distances
        pp.pprint(self.distance_mappings)
        """

    def store_hueristic(self):
        self.hueristics = {}
        for line in self.sunday_traffic_lines:
            key, value = line.split(' ')
            self.hueristics[key] = int(value)

    def perform_bfs_dfs(self, bfs=True):
        current_node = self.start_state
        path = []
        path_cost = 0
        ## Goal test
        if current_node == self.goal_state:
            return {'path': path, 'path_cost': path_cost}
        queue = [self.start_state]
        explored = []
        while queue:
            if bfs:
                node = queue.pop(0)
                #print 'pop: {}'.format(node)
            else:
                node = queue.pop(0)
            path.append(node)
            if node not in explored:
                explored.append(node)
                try:
                    children = self.graph[node]
                except KeyError:
                    children = []
                #print children
                if self.goal_state in children:
                    path.append(self.goal_state)
                    return {'path': path, 'path_cost': range(0,len(path))}
                #queue.extend([child for child in children if child not in explored])
                queue = [child for child in children if child not in explored] + queue
                #queue.extend(children - explored)
            #print queue
        return {'path': path, 'path_cost': range(0,len(path))}

    def perform_bfs_dfs_node(self, bfs=True):
        current_node = Node(label=self.start_state, parent=None, cost = 0)
        path = []
        path_cost = 0
        ## Goal test
        if current_node.label == self.goal_state:
            return {'path': [self.goal_state], 'path_cost': [0]}
        queue = [current_node]
        explored = []
        distance_mappings = {k:1 for k in self.graph.keys()}
        while queue:
            if bfs:
                curr_node = queue.pop(0)
            else:
                curr_node = queue.pop(0)
            if curr_node not in explored:
                explored.append(curr_node)
                children_nodes = curr_node.get_bfs_children(self.graph)
                for node in children_nodes:
                    if node.label == self.goal_state:
                        return node.traceback(astar=False)
                #queue.extend([child for child in children_nodes if child not in explored])
                #queue.extend(children - explored)
                if not bfs:
                    queue = [child for child in children_nodes if child not in explored] + queue
                else:
                    queue.extend([child for child in children_nodes if child not in explored])
            queue_labels = [q.label for q in queue]
            #print queue_labels

    def perform_ucs(self):
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
                if (child.path_cost, child) not in frontier.queue:
                    # insert
                    frontier.put((child.path_cost, child))
                else:
                    # find index,
                    index = [i for i,v in enumerate(frontier.queue) if v[1] == child]
                    frontier_element = frontier.queue[index[0]]
                    frontier_child_dist = frontier_element[0]
                    ## change distamce
                    if child.path_cost < frontier_child_dist:
                        frontier.queue[index[0]] = (child.path_cost, Node(child.path_cost, child.label, child.parent))

    def perform_astar(self):
        frontier = [] #Q.PriorityQueue()
        hueristic_scores = self.hueristics
        start_node = Node(0, self.start_state, None, 0, hueristic_scores[self.start_state])
        frontier.append(start_node) #((start_node.path_cost, start_node))
        explored = []
        print frontier
        while frontier:
            curr_node = min(frontier, key=lambda n: n.G+n.H)
            print curr_node.label
            if curr_node.label == self.goal_state:
                print 'traceback'
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
    f_input = InputFile(filepath)
    """
    attrs = vars(f_input)
    for key, value in attrs.iteritems():
        print '{}: {}'.format(key, value)
    """

def write_output(path, path_cost):
    print path
    print path_cost
    with open('output.txt', 'w') as f:
        writer = csv.writer(f, delimiter=' ')
        writer.writerows(zip(path, path_cost))

if __name__ == '__main__':
    read_input(sys.argv[1]) #('input.txt')
    #read_input('input.txt')

