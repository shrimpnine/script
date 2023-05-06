#!/bin/bash

_PATH=./
_outPATH="$_PATH"128k

function _func0()
{
	bit_rate=`ffprobe -v quiet -show_format -select_streams a ${1} |grep bit_rate=`
	bit_rate=${bit_rate#*=}
	#128000 = 128kb, 256000 = 256kb, 944225 = 922kb
	if (( $bit_rate > 160000 ));then
		_outfile=${1#*.}
		ffmpeg -i ${1} -b:a 128k $_outPATH${_outfile%.*}.mp3 -y
	else
		cp -a ${1} $_outPATH
	fi
}

OLDIFS="$IFS" #备份旧的IFS变量
IFS=$'\n' #修改分隔符为换行符
if [ ! -d $_outPATH ] ; then
	mkdir $_outPATH
fi
for i in `find $_PATH -path $_outPATH -prune -o -type f -iname "._*" -prune -o -iname "*.mp3" -print`
do
	_func0 $i
done
for i in `find $_PATH -path $_outPATH -prune -o -type f -iname "._*" -prune -o -iname "*.flac" -print`
do
	_func0 $i
done
IFS="$OLDIFS" #还原IFS变量
exit

