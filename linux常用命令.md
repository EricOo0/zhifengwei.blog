# 内存：  
> df -h  (-h  使用人类可读的格式) --当前路径下各文件的大小  
du -h --各磁盘的大小  
# 网络：  
>tcpdump -i any -n -nn -s0 -A port 11123 （-i 接口 -n 指定将每个监听到数据包中的域名转换成IP地址后显示 -nn 指定将每个监听到的数据包中的域名转换成IP、端口从应用名称转换成端口号后显示  -s 表示从一个包中截取的字节数。0表示包不截断，抓完整的数据包。默认的话 tcpdump 只显示部分数据包,默认68字节  port 端口）  
netstat -ntlpa显示所有连线中的Socket。-l或--listening   显示监控中的服务器Socket。-p或--programs   显示正在使用Socket的程序识别码和程序名称。-n或--numeric   直接使用IP地址，而不通过域名服务器。
# 系统：
>uname -a 查看系统信息  
whoami:查看当前登录用户  
useradd test -d /home/test/ -p 123创建用户;ps($表示普通用户, #特权用户)  
su - usrname;切换目录  
service：service service.name start/stop/restart/reload/status  ；service命令是Redhat Linux兼容的发行版中用来控制系统服务的实用工具，它以启动(start)、停止(stop)、重新启动(restart)和关闭系统服务，还可以显示所有系统服务的当前状态(status)。  
nice命令用于以指定的进程调度优先级启动其他的程序。  
inode（索引节点）：本质是一个结构体，存储了文件相关的一些数据；指向磁盘上的一个文件  
    可以用stat 命令查看文件的inode信息  
    硬链接：多个文件名只指向同一个inode节点；修改一个文件会影响其他所有文件，但是删除一个硬链接不影响其他；  
    软连接：符号链接；inode节点不同，但a的内容就是b的路径  
# 数据库    
>yum list | grep mysql命令来查找yum源中是否有MySQL  
show databases;查看有哪些表  
create database [databasename];创建一个数据库  
use database；选择数据库  
grant previledge on *.* to 'slave'@'ip' identified by 'password'；分配权限  
show *；查看你想查的信息  
在标准的SQL语句中，一次插入一条记录的INSERT语句只有一种形式。  
INSERT INTO tablename(列名…) VALUES(列值);
而在MySQL中还有另外一种形式，就是set
    INSERT INTO tablename SET column_name1  =  value1, column_name2  =  value2，…;  
修改表属性：alter table * modify *  
            update table_name set *  
创建分区：create TABLE tblname (upload_date string,FTarget string) PARTITION BY RANGE (upload_date) (partition p_20210615 values less than (20210615) )  
查看某个分区信息：  
show create table partition_test；查看创建表的语句    
show table status；看表是不是分区表    
information_schema.PARTITIONS 存储分区信息，可以去这张表查  
SELECT * FROM tr p2;查看这个分区的信息  
alter table partition_test add partition  (partition p_20210616 values less than (20210616));增加分区  
数据表备份：create table t2 like t1 ;insert into  t2 select  * from  t1;  
数据库更名：RENAME TABLE old_table_name TO new_table_name  
字段更名：alter table <表名> change <字段名> <字段新名称> <字段的类型>  
数据追加：concat函数--update tblname set col=CONCAT(col,",https") where F=""    
一些函数：count，distinct  

# 其他
>md5sum:计算md5校验值  
diff ： 比较文件不同 ； -y并列方式输出 -r 递归对比文件夹下文件  
grep :正则表达式提取要加-E  ；-o 匹配特定模式  
sed 流编辑器，参数 s可以替换文本 参数/g可以匹配所有；cat test |sed 's/&/\t/g'  
# 调试
>gdb  
nm+文件名：查看符号表  
ldd 看共享依赖库  
xargs（英文全拼： eXtended ARGuments）是给命令传递参数的一个过滤器，也是组合多个命令的一个工具。somecommand |xargs -item  command  
# shell
>$()和` `：命令替换 echo today is $(date "+%Y-%m-%d") #先完成引号里的命令行，然后将其结果替换出来，再重组成新的命令行  
${}：变量替换  
$0：当前Shell程序的文件名  
dirname $0，获取当前Shell程序的路径  
cd `dirname $0`，进入当前Shell程序的目录  
ls-l :rwx(Owner)r-x(Group)r-x(Other); owner;group;  
ps: -e显示所有进程，-f 显示UID,PPIP,C与STIME栏位。-u uid or 。username 选择有效的用户id或者是用户名.-x 显示没有控制终端的进程，同时显示各个命令的具体路径。  
wc：- c 统计字节数。 - l 统计行数。 - w 统计字数。不加参数显示 行数、字数、字节数、文件名  
ls: -l：列出目录下子目录和文件的详细信息;-r排序时按倒序;按最后修改时间排序;-h以容易理解的格式输出内存--ls -lrthz  
crontab -l 可以看系统的定时任务 -e可以编辑定时任务  
eval会对后面的cmdLine进行两遍扫描，如果第一遍扫描后，cmdLine是个普通命令，则执行此命令；如果cmdLine中含有变量的间接引用，则保证间接引用的语义。  
source 在当前bash环境下读取并执行FileName中的命令;通常./执行会新建一个子shell  
basename命令用于打印目录或者文件的基本名称  
dirname命令打印文件路径名  
trap用法：trap command signal； signal是指接收到的信号，command是指接收到该信号应采取的行动  
echo $$：$$表示pid  
nohub和&区别：都是将进程放到后台执行，但&在账户退出或者控制台关闭的时候进程就被结束；nohub可以在账户退出后继续运行--但账户非正常退出也有可能结束任务，最好用exit退出账户  
flag=`ps aux | grep ${process} | awk '$11~/ewp_agent$/ {print $2}' |wc -l`： / */中间的字符串awk会查找和处理对应行；a~b a中是否包含b
=~ :右边式子按正则表达式展开    
# 正则表达式  

>行首定位:^
行尾定位:$
单个字符匹配:.

# md工具
>typora