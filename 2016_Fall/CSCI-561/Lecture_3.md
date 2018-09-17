In SLD the hueristic needs to be zero at the goal
Worst case: O(b^m) guided DFS

Space complexity: O(b^m) --> Priority queue for the cheapest cost

A*

f(n) = g(n)+h(n) 
h(n) heuristic 


f(ARAD) -> Expand to Sibiu, Tinisora, Zerind 

A* is tree search 

We maintain a priority queue  --> IMP
h is admissible.


G2 submpotima. f(G2) = g(G2) (since h(G2)=0) > h(G) >= f(n) since h is admissible
so it is never going to expand G2.



If if we use h(n)/2 instead of h(n) is, it is simply going to shrink the black thing
it is still going to be optimal. It will just change the number of nodes expanded.
Space complxity is still exponential.

Hueristic quality: Reduce the effective branching factor


## search graph

UCS search: g(n) => Only care about the edges
Explored:  S -> B -> A -> C -> F -> D -> G3
Open: S -> B1A3C5  -> A3C3F3 -> C3F3E10G13 -> F3E10G13G_3[14] -> D4E10G13G_3[14] -> G_2[9]

H-->

S -> B1C3A9 -> C3A9 -> G_3[0]

A* ->

S -> B2C8A12 -> C6 F8 -> open C6 -> G_3[14] -> Open F8 -> D8 -> G_2[9]  

