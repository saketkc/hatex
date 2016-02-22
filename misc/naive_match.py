from __future__ import division
from __future__ import print_function
import sys

def naive_match(pattern, text):
    len_t = len(text)
    len_p = len(pattern)
    assert len_t >= len_p
    j=0
    for i in range(0,len_t-len_p+1):
        for j in range(0, len_p):
            if pattern[j] == text[i+j]:
                if j==len_p-1:
                    print('Matches at: {}'.format(i+1))
                    print('{}'.format(text))
                    print('{}'.format(pattern.rjust(i+len_p)))
                continue
            else:
                break

if __name__=='__main__':
    naive_match(sys.argv[1], sys.argv[2])
