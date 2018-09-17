#!/usr/bin/env python
"""
Script to replace consecutive ',' with NULL
"""
import os
import sys
def main(argv):
    lines = []
    with open(argv,'r') as f:
        for line in f:
            split = line.strip().split(',')
            replace_s = map(lambda x: "\"{}\"".format(x) if x else 'NULL', split)
            join_s = ','.join(replace_s)
            lines.append(join_s)
    root, ext = os.path.splitext(argv)
    out_file = '{}_null.csv'.format(root)
    with open(out_file, 'w') as f:
        for l in lines:
            if not l.startswith('NULL'):
                f.write('{}\n'.format(l))

if __name__ == '__main__':
    main(sys.argv[1])

