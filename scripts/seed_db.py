import glob
import hashlib
import psycopg2
import sys

# called as `python seed_db.py <connection string> <location_of_images>

def simple_hash(s):
    return hashlib.md5(s.encode()).hexdigest()[0:10]

conn = psycopg2.connect(sys.argv[1])
cur = conn.cursor()

values = []
for i,img in enumerate(glob.glob(sys.argv[2] + '/*')):
    values.append((i+1, simple_hash(img), img, 1500))

cur.executemany('INSERT INTO comparison VALUES (?,?,?,?)', values)
conn.commit()

cur.close()
conn.close()
