import glob
import hashlib
import sqlite3
import sys

# called as `python seed_db.py <db_file> <location_of_images>

def simple_hash(s):
    return hashlib.md5(s.encode()).hexdigest()[0:10]

conn = sqlite3.connect(sys.argv[1])
values = []
for i,img in enumerate(glob.glob(sys.argv[2] + '/*')):
    values.append((i+1, simple_hash(img), img, 1500))

conn.executemany('INSERT INTO comparison VALUES (?,?,?,?)', values)
conn.commit()
conn.close()
