import os
import sys

for i in sys.argv :
	if os.path.exists(i) :
		_file_path=os.path.split(i)[0]
		_file=os.path.split(i)[1]
		_filename=os.path.splitext(_file)[0]
		_filesuffix=os.path.splitext(_file)[1]
		_new_filename=_filename.encode("gbk").decode("shift_jis")
		_new_filename=_file_path + os.sep + _new_filename + _filesuffix
		os.rename(i,_new_filename)
