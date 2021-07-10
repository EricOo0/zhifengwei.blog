# nginx 学习笔记
## 底层原理  
>nginx启动时分为1个master进程和和一系列工作进程（nginx.conf配置工作进程数）；master进程管理工作进程，工作进程负载各种工作  
底层架构：epoll+进程池   
每来一个进程，就交给一个工作进程出来，不会阻塞  
启动时，master建立好listen套接字，监听配置好的端口，然后会fork出n个工作进程，共享这个socket；当有链接到来，所有worker线程的listen套接字变为可读，各worker竞争，获得锁的接受请求；

>nginx 可以作为http服务器，反向代理服务器等。支持fastcgi等  
做反向代理时：Nginx可以根据不同的正则匹配，采取不同的转发策略，比如图片文件结尾的走文件服务器，动态页面走web服务器，只要你正则写的没问题，又有相对应的服务器解决方案，你就可以随心所欲的玩。（起一个转发的作用 nginx.conf）  
负载均衡：  
内置负载均衡算法：轮询round robin、ip hash等  
https://www.runoob.com/w3cnote/nginx-setup-intro.html
底层是epoll？一个master接受连接worker负责转发
cgi（java中是jsp和servlet）：
可以在服务端执行请求的程序并回复--动态网页实现
nginx配置 conf/nginx.conf --部署网站
        配置.cgi/.sh文件转发到fcgiwraper，由fcgi调用程序执行 标准输出是回复，标准输入是请求体


