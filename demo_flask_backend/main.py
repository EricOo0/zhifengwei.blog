from flask import Flask,request,Response,jsonify,session,render_template
import json
from flask.helpers import url_for
from werkzeug.utils import redirect
from db.db import DB_con

from auth.auth import Auth
import os
app = Flask(__name__,template_folder='template',static_folder="static",static_url_path="/backend/static")
app.config['SECRET_KEY'] = os.urandom(24)

'''
@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/test2/<name>')
def hello_test2(name):
    return 'Hello, %s!' % name

@app.route('/test2')
def hello_test():
    print("hello")
    return 'Hello, test!'
'''   

@app.before_request
def befor_request():
    if (request.path == "/login"):
        #访问登陆页面；白名单
        ret={
            'code':200
            
        }
        return None
    
    #访问其他页面 每次访问先确认身份,没有session则跳转到登陆界面
    print(session.get("usr"))
    if(not session.get("usr")):
        #没有信息
        print(session.get("usr"))
        ret={
            'code':405,
            'data':{
                'url':'/login',
                'auth_type':'login',
                'msg':'usr not login'

            }
        }
        return jsonify(ret)
    else:
        return None


@app.route('/login',methods=['POST','GET'])
def login():
    if (request.method=='GET'):
        return "login"
    else:
        #登陆验证
        # 登陆参数必须携带
        param=request.args
        if(not param.get('usrname')):
            ret={
                'code':404,
                'data':{
                    'url':'/login',
                    'auth_type':'login',
                    'msg':'usr not login'

                }
            }
            return jsonify(ret)
           
        #验证usrname并且设置seesion
        usrname=param.get('usrname')
        auth=Auth(usrname)
        ret=auth.usr_auth()
        if(not ret):
            #用户不存在
            ret={
                'code':404,
                'data':{
                    'url':'/login',
                    'auth_type':'login',
                    'msg':'usr not exist'

                }
            }
            return jsonify(ret)
        #用户存在，给一个cookie,设置session
        session["usr"]=usrname
        return redirect(url_for('index'))
        
    

@app.route('/',methods=['POST','GET'])
def index():
    
    resp = Response("你好，{}".format(session["usr"]))
    #设置cookie
    #resp.set_cookie('usrname',usrname)
    return resp

@app.route('/getusr',methods=['POST','GET'])
def get_usrinfo():
    #cookie_name=request.cookies.get('usrname')
    #print(cookie_name)
    print(session.get("usr"))
    if(not session.get("usr")):
        #没有信息
        return redirect(url_for('login'))
    
    return "get_usrinfo:{}".format(session.get("usr"))


if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=8080)


