import pygit2
import os

repo = pygit2.Repository("..")
branch_name = repo.head.shorthand
rev_id = repo.revparse_single('HEAD').short_id

meta = open('Meta.ini', 'r')
meta_new = open('Meta.ini.tmp', 'w')

for line in meta.readlines():
	if line.startswith('Version='):
		meta_new.write("Version=git-{}-{}\n".format(branch_name, rev_id))
	else:
		meta_new.write(line)
		
meta.close()
meta_new.close()
	
os.replace('Meta.ini.tmp', 'Meta.ini')
