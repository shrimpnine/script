#! /bin/bash
#根据文件后缀命名为文件本身的sha1值
_photo_suffix=(jpg png heic jpeg) #文件名后缀
_path=./ #执行路径
if [[ -n ${1} ]] ;then #是否有第1个参数
	_path=${1}
fi
if [ ! -d $_path ] ;then
	echo "path error...'"${1}"'"
	exit 2
fi

OLDIFS="$IFS" #备份旧的IFS变量
IFS=$'\n' #修改分隔符为换行符
for _suffix in ${_photo_suffix[@]}
do
	for _file in `find $_path -type f -iname "*.$_suffix"`
	do
		_sha1=`shasum -a 1 $_file`
		_sha1=${_sha1%% *}
		if [[ ! $_file == $_path/$_sha1.$_suffix ]] ; then
			mv -v $_file $_path/$_sha1.$_suffix
		fi
	done
done
IFS="$OLDIFS" #还原IFS变量
