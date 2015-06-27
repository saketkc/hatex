Name: Saket Choudhary
ID: 2170058637


Notes
-------

I had serious issues dealing with empty rows and
columns while exported from excel.
I am not sure if those were intentional, but
MySQL had issues dealing with such empty 
rows/columns(See for example the last 3 lines
of courses.csv)

The python script 'make_null.py' takes the
excel-> csv exported versions of tables and
creates another 'cleaned' csv.

The '*_null.csv' are generated using the foresaid
python script and are input to 'createdb.sql'.

I am also not sure, if MySQL takes local paths for
reading files, but `createdb.sql` mentions
them as hardcoded paths which MUST be changed
before running it. I do not know of a cleaner
way to do this.(LOAD LOCAL does not work universally)


