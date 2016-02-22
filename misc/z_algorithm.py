"""Z-algorithm in Python
"""

from __future__ import division
from __future__ import print_function
import sys

def match(pattern, p1, p2):
    """Returns index of string till where matching occurs
    Arguments
    ---------
    pattern: string
    p1: First Position to start matching from [0-based]
    p2: First Position to start matching pattern[p1] [0-based]

    Returns
    p1: Last matching index
    """
    while max(p2,p1)<len(pattern) and pattern[p1] == pattern[p2]:
        p1+=1
        p2+=1
    return p1

def calc_Z(pattern):
    """Calculate Z values using Z-algorithm as in Gusfield"""
    Z = []
    len_p = len(pattern)
    Z.append(len_p)
    Z.append(0)
    l=1
    Z[1] = match(pattern, 0, 1)
    r = Z[1]+1
    l = 1
    for k in range(2, len_p):
        if k>r:
            zk = match(pattern,0, k)
            r = zk+k
            l = k
        else:
            b = r-k
            ks = k-l
            if Z[ks]<b:
                zk = Z[ks]
            else:
                q = match(pattern, r+1, b)
                zk = r-k
                r = q-1
                l = k
        Z.append(zk)
    print(Z)

if __name__=='__main__':
    calc_Z(sys.argv[1])
