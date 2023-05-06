# sys_backup.sh
	example: sys_basckup.sh -l ~/sys_backup_list -y -7 -p 12345 -o ~/sys_backup/
	如果sys_backup_list中包含root目录 则需要sudo
	自定义指定list系统备份打包
	脚本可方便手动备份指定的配置文件
	恢复 cp -av <bakcup> /
		默认获取当前目录下的sys_backup_list文件
		sys_backup_list文件可用#作为标记注释
		sys_backup_list文件中可用目录 或者具体文件名 建议为绝对目录
		忽略.DS_Store和._前缀的Mac缓存文件
		打包功能tgz
		保留目录的权限与文件的权限
		创建目录的时候是用的root权限创建的
		打包还原的权限问题
		sys_backup_list文件带"#"的行将被忽略 不能在结尾添加"#"
# m3ulist.sh
	将根据文件夹分类的文件处理为m3u的list
