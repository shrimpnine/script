#!/bin/zsh

git clone https://github.com/godotengine/godot-docs.git
cd ./godot-docs/classes

_dir=$PWD

if [ -d $_dir ] ; then
	cd $_dir
else
	echo "No folder found."
	exit
fi

touch class.txt
echo "" > class.txt

for i in `ls *.rst`
do
	cat $i | while read line
	do
		if [[ $line =~ "_class_" ]] ; then
			line=${line##*_class_}
			line=${line%%:*}
#			line=$i": "$line
			echo $line >> class.txt
			break
		fi
	done
done
