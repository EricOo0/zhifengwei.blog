# 简单的利用flask搭建登陆系统后台

## 访问任意界面需要先验证seesion

@app.before_request  
通过装饰器，请求先判断访问的路径  
if (request.path == "/login"): 如果是访问登陆界面直接放行，跳转到login  
如果不是  
则验证是否带有seesion，没有session则拦截，返回json让前端去访问login  
如果有session  
则正常访问页面

## 登陆界面login
通过request访问判断  
如果是get，返回login.html页面  
如果是post，验证登陆用户身份，查询是否带有usrname参数；查询数据库是否有该用户；设置session；跳转到主页  

## 数据库
使用pymysql连接数据库，每次请求连接一次数据库，每次请求介绍关闭--感觉不适用于高并非情况

## 用户认证
认证逻辑在/auth下