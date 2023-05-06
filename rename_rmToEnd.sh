#!/bin/zsh

#rename.sh mkv ]
#删除当前目录下mkv后缀的文件中]后面的所有名字 不包含]


if [[ ! ${1} ]]; then
	echo "没有输入参数，请输入要处理的文件后缀。"
	exit
fi

if [[ ! ${2} ]]; then
	echo "没有输入参数，请输入要匹配的字符串。"
	exit
fi

_IFS=$IFS
IFS=$(echo -en "\n\b")

for i in `ls ./*.${1} | grep "${2}"`
do
	temp_name=${i%%${2}*}.${1}
	if [ -f $temp_name ] ; then
		echo "有相同的文件: $i"
	else
		mv -vn $i $temp_name
	fi
done
ls -l *.${1}
IFS=$_IFS