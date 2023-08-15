#!/bin/bash
_PATH=/Music/.data/
_outPATH=/Music/.data128k/

if [ ! -d $_outPATH ] ; then
	mkdir $_outPATH
fi

OLDIFS="$IFS" #备份旧的IFS变量
IFS=$'\n' #修改分隔符为换行符
for i in `find $_PATH -type f -iname "._*" -prune -o -iname "*.flac" -print -o -iname "*.mp3" -print`
do
	_outfile=${i##*/}
	_outfile=${_outfile%.*}
	if [[ ! `find $_outPATH -type f -iname "._*" -prune -o -iname "*$_outfile*" -print` ]] ;then
		#echo "未找到的文件: $i"
		bit_rate=`ffprobe -v quiet -show_format -select_streams a ${i} |grep bit_rate=`
		bit_rate=${bit_rate#*=}
		#128000 = 128kb, 256000 = 256kb, 944225 = 922kb
		if (( $bit_rate > 160000 ));then
			#echo "开始转换${i}"
			ffmpeg -i ${i} -b:a 128k $_outPATH/${_outfile%.*}.mp3 -n
		else
			#echo "开始拷贝${i}"
			cp -n ${i} $_outPATH
		fi
	fi
done

IFS="$OLDIFS" #还原IFS变量

exit 1

