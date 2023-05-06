#!/bin/bash
#需要在目录下执行bash
#自动批量解压 https://www.oldmanemu.net 下载的PS3资源
#移动重复下载的(1)文件到../surplus

_dir=PS3CH #文件夹前缀
_surplus=../surplus
if [ ! -d $_surplus ] ; then
	mkdir $_surplus
fi
find -type f -name "$_dir*(*).rar" -exec mv -v {} $_surplus \;

#将有分p和没分p的rar文件夹移动到../trueDone
_trueDone=../trueDone
if [ ! -d $_trueDone ] ; then
	mkdir $_trueDone
fi
for i in `find -type d -name "$_dir*"`
do
	if [[ `find $i -type f -name "${i##*/}.part01.rar"` || `find $i -type f -name "${i##*/}.part1.rar"` || `find $i -type f -name "${i##*/}.rar"` ]] ; then
		mv -v $i $_trueDone
	fi
done

#解压到../trueExDone
_trueExDone=../trueExDone
if [ ! -d $_trueExDone ] ; then
	mkdir $_trueExDone
fi
for i in `find $_trueDone -type d -name "$_dir*"`
do
	find $i -type f -name "${i##*/}.rar" -exec unrar -p"oldmanemu.net" x {} $_trueExDone \;
	find $i -type f -name "${i##*/}.part1.rar" -exec unrar -p"oldmanemu.net" x {} $_trueExDone \;
	find $i -type f -name "${i##*/}.part01.rar" -exec unrar -p"oldmanemu.net" x {} $_trueExDone \;
done

exit
