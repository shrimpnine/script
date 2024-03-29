#!/bin/bash
#example: sys_basckup.sh -y7 -p 123 -l ./sys_backup_list -o ~/backup/
#-l 指定sys_backup_list文件路径 默认提取当前目录下的sys_backup_list文件
#-y -n 是否打包
#-7 用7z打包 默认tar
#-p 123 添加7z打包的密码
#-o 指定打包输出目录 默认输出到当前执行脚本的目录下

_packge=false #是否打包
_packge_no=false #是否跳过打包
_packgecmd="tar" #用什么方式打包 默认tar
_packgecmd_password="" #打包密码

_pwd=`pwd` #默认提取当前目录下的list文件
_sys_backup_list="sys_backup_list" #默认list文件的名字
_out="$(date +%Y%m%d_%H%M%S)_sys_backup" #输出文件夹的名字
_outpath="$_pwd/$_out" #目标目录 默认当前目录下的out目录

while getopts 'l:o:p:yn7' opt; do
    case ${opt} in
    	l)
    	_pwd=${OPTARG%/*}
    	_sys_backup_list=${OPTARG##*/} #指定list文件的名字
    	;;
        o) _outpath="$OPTARG/$_out" ;;
        p) _packgecmd_password=$OPTARG ;;
        y) _packge=true ;;
        n) _packge_no=true ;;
        7) _packgecmd="7z" ;;
        ?) echo "# Argument Error：$OPTARG" 1>&2 ;exit 2
    esac
done

if [ ! -f $_pwd/$_sys_backup_list ] ; then #检查list文件是否存在
	echo "# Cannot access $_pwd/$_sys_backup_list..." 1>&2
	echo "# Please create and designate $_sys_backup_list." 1>&2
	exit 2
fi

echo "# Backup start..."

if (! $_packge_no );then #没有指定-y -n 参数时 选择是否打包
	if (! $_packge );then
		while true
		do
			echo "# Packed as *.$_packgecmd? [Y\n]"
			read y_n
			if [[ -z "$y_n" ]] ; then
				y_n="y"
			fi
			if [[ "$y_n" =~ (y|Y) ]] ; then
				_packge=true
				break
			elif [[ "$y_n" =~ (n|N) ]] ; then
				break
			else
			    continue
			fi
		done
	fi
fi

_IFS="$IFS" #备份IFS变量
IFS=$'\n' #修改分隔符
declare -a arrlistfile #初始化 文件数组
for line in `cat $_pwd/$_sys_backup_list` #lsit文件 存为数组 将arrlistfile过滤为绝对目录
do
	if [[ ! $line =~ (^$)|(^#)|(^.+#) ]]; then #忽略空行和注释行
		if [[ $line =~ (/$) ]]; then #清理目录末尾的/字符
			line=${line%/*} #从右向左截取第一个/后面的字符串
		fi
		if [[ $line =~ (^./) ]]; then #捕获 ./ 开头的line
			arrlistfile=("${arrlistfile[@]}" $_pwd${line#*.}) #去掉. 添加$_pwd
		elif [[ $line =~ (^/) ]]; then #捕获 / 开头的line
			arrlistfile=("${arrlistfile[@]}" $line)
		fi
	fi
done

#arrlistfile=($(awk -v RS=' ' '!a[$1]++' <<< ${arrlistfile[@]})) #清理重复的行
declare -a _new_arrlistfile #初始化 文件数组

for line in "${arrlistfile[@]}"
do
	if [ -e $line ] ; then #判断目录或文件是否存在
		if [ -d $line ] ; then #如果是目录
			for d in `find $line -type d` #列出目录下的所有文件文件夹
			do
				mkdir -p $_outpath$d #输出文件夹内创建目录
			done
			for f in `find $line -type f` #列出目录下的所有文件
			do
				if [[ ! $f =~ "._"|".DS_Store" ]] ; then #忽略.DS_Store和._前缀的Mac缓存文件
					_new_arrlistfile=("${_new_arrlistfile[@]}" $f)
				fi
			done
		elif [ -f $line ] ; then #如果是文件 创建文件夹
			#判断备份目录是否有对应文件夹 是就直接复制 否就创建对应目录
			if [ -d $_outpath${line%/*} ] ; then
				_new_arrlistfile=("${_new_arrlistfile[@]}" $line)
			else
				mkdir -p $_outpath${line%/*}
			fi
		fi
	else
		echo "## \"$line\": No such file or directory. Be ignored" 1>&2
	fi
done

_file_sum=0
for line in "${_new_arrlistfile[@]}"
do
	cp -av "$line" "$_outpath$line"
	((_file_sum++))
done

IFS="$_IFS" #还原IFS变量

if $_packge ; then #打包
	cd ${_outpath%/*}
	if [[ $_packgecmd == "tar" ]] ; then
		echo "# Packing.... $_out.tgz"
		tar -cvpzf $_out.tgz $_out --remove-files
	elif [[ $_packgecmd == "7z" ]] ; then
		echo "# Packing.... $_out.7z"
		if [[ $_packgecmd_password != "" ]] ; then
			7za a -sdel -mhe=on -p$_packgecmd_password $_out.7z $_out
		else
			7za a -sdel $_out.7z $_out
		fi
	fi
	echo "******"
	echo "# Packing Complete."
fi

echo "# Have been $_file_sum files backup."
echo "# Done."
