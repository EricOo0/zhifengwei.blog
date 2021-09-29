**## redis 相关命令**



查看所有keys： keys *

清空数据库数据：flushall；FLUSHDB 只清空当前db

DB的key数量： DBSIZE 

查看redis信息：info

保存和查看：BGSAVE-把数据保存到磁盘；lastsave 上次保存的时间戳

debug：monitor 查看redis收到的所有命令

redis目录：CONFIG GET dir；将dump.rdb移动到这就可以恢复备份