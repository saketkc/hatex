#!/usr/bin/env python
from Bio import SeqIO
import numpy as np
import sys
import matplotlib.pyplot as plt
def sumzip(*items):
    return [sum(values) for values in zip(*items)]
for index, seq_record in enumerate(SeqIO.parse(sys.argv[1], "fastq")):
    if index==0:
        count_dict = {i: {"A":0, "G":0, "C":0, "T":0, "N":0} for i in range(1, len(seq_record)+1)}
    for j in range(0, len(seq_record)):
        nt = seq_record.seq[j]
        j = j+1
        count_dict[j][nt]+=1

print count_dict
N = len(count_dict)
A = [nuc['A'] for nuc in count_dict.itervalues()]
T = [nuc['T'] for nuc in count_dict.itervalues()]
G = [nuc['G'] for nuc in count_dict.itervalues()]
C = [nuc['C'] for nuc in count_dict.itervalues()]
NN = [nuc['N'] for nuc in count_dict.itervalues()]

ind = np.arange(N)    # the x locations for the groups
width = 0.35       # the width of the bars: can also be len(x) sequence



p1 = plt.bar(ind, A,   width, color='r')
p2 = plt.bar(ind, T, width, color='y', bottom=sumzip(A))
p3 = plt.bar(ind, G, width, color='g', bottom=sumzip(A,T))
p4 = plt.bar(ind, C, width, color='b', bottom=sumzip(A,T,G))
p5 = plt.bar(ind, NN, width, color='c', bottom=sumzip(A,T,G,C))


plt.ylabel('Frequency')
plt.title('Position in read')
plt.xticks(ind+width/2., ('G1', 'G2', 'G3', 'G4', 'G5') )
#plt.yticks(np.arange(0,81,10))
plt.legend( (p1[0], p2[0], p3[0], p4[0], p5[0]), ('A', 'T', 'G', 'C', 'N') )

plt.show()
