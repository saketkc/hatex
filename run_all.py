import os
import sys
import glob

for dir in os.walk('./'):
    d = dir[0]
    if '.git' in d:
        continue
    print('python ./make_index.py {} > {}/index.html'.format(d,d))
    os.system('python ./make_index.py {} > {}/index.html'.format(d,d))
