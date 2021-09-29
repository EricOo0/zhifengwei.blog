# web服务器（Go版）

基础包： net/http，log

基本api：

​	注册路由：http.HandleFunc("/", HelloServer) --"/"是请求路径，调用hellpserver函数

​	启动服务器并监听端口： err := http.ListenAndServe(":8080", nil)  --返回值是error,启动server并bind到127.0.0.0:8080上

​	解析参数：requset.phase()--用于解析参数，默认不解析

​					  fmt.Println(r.Form)
​					  fmt.Println(r.URL.Path)

​	构造回复报文：fmt.Fprintf(w, "Hello client!") 

​	设置状态码：w.WriteHeader(401) 

​	设置响应头：w.Header().Set("Location", "https://xxx.com")   

​							w.WriteHeader(301)

报文解析：

​	http报文分为 状态行 响应头 响应主体

​	客户端的请求信息都封装到了request对象中了，调用路由时会将http.request传给函数；ResponseWriter用来创建回复http的响应

​		--func HelloServer(w http.ResponseWriter, r *http.Request){} --一个路由函数

​	获取host：r.Host

​	获取浏览器信息：r.UserAgent()

日志打印：

​	log.fatal("ListenAndServe:",err) :完成的功能：完成打印，退出程序

​	log.println():打印日志