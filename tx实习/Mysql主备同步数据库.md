# Mysql主备同步数据库

 搭建主从同步的db；

  ## 主从同步作用：

​    从服务器起备份作用；

​    主服务器挂掉的时候，从服务器可以起作用；

​    可以用来做读写分离 

  ## 分工-流程：

​    主数据服务器：主要用来从业务服务写入数据或者修改更新数据。

​    从数据服务器：主要用来读取业务所需要的数据

​    二进制日志：用来存储写入以及更新的数据信息

​    中继日志：承接主服务器数据信息，转存在从服务器上

​    I/O线程：监听主服务器是否发生数据更改的行为

​    SQL线程：将主服务器数据更改的数据从中继日志文件中读取数据写入到从数据服务器中

当主数据服务器master进行写入数据或者更新数据操作的时候，数据更改会记录在二进制日志（binary log file）中，主服务器master与从服务器slave进行通讯的是I/O线程，它将修改的数据异步复制写入到slave服务器的中继日志（relay log file）中,从服务器slave与中继日志之间通信使用SQL线程，SQL线程可以异步从中继日志中读取数据后再写入到自己的数据库中，就完成了数据的主从同步功能。

![master-slave](C:\Users\zhifengwei\Desktop\note\image\master-slave.png)

## 搭建

> 1、
>
> centos默认安装的是mariadb，是mysql的一个开源分支，使用基本一致。
>
> 先安装maridb-server：
>
> yum -y install mariadb mariadb-server
>
> 启动服务：service mariadb start
>
> 2、 
>
> mysql的配置文件位置：
>
> /etc/my.cnf
>
> 用/usr/bin/mysql -v --help 可查看默认配置从哪读
>
> 3、配置数据库
>
> 主数据库配置：如图，打开二进制日志功能，id为1，需要同步的数据库为master_test；
>
> 从数据库配置:  id为2
>
> ![image-20210804163636968](C:\Users\zhifengwei\AppData\Roaming\Typora\typora-user-images\image-20210804163636968.png)
>
> ![image-20210804163646523](C:\Users\zhifengwei\AppData\Roaming\Typora\typora-user-images\image-20210804163646523.png)

> 4、在主数据库创建同步用户并授权
>
>  grant replication slave on *.* to 'slave_test'@'ip_addr' identified by '123456';
>
>  创建用户'slave_test'@'ip_addr'并授于replication slave权限，拥有此权限可以查看从服务器，从主服务器读取二进制日志。
>
>  用show master status 可以查看master数据库当前正在使用的二进制日志及当前执行二进制日志位置
>
>![master_status](C:\Users\zhifengwei\Desktop\note\image\master_status.png)
>
>5、在从服务器上输入命令修改主服务器设置：
>
>change master to master_host='ip_addr',master_user='slave_test',master_password='123456',master_log_file='mysql-bin-master.000001',master_log_pos=405;
>
>6、从服务器上启动 slave服务
>
>start slave；
>
>7、 查看slave状态
>
>show slave status\G
>
>8、如果需要互为主备，则将上述过程反过来重复一遍
>
>如果主数据库原本就有数据，需要先将数据dump到从数据库在启动slave