import pymysql
pymysql.install_as_MySQLdb()

class DB_con:
    def __init__(self):
        pass
    def connect(self):
        
        conn = pymysql.Connect(
        host = '127.0.0.1',
        port = 3306,
        user = 'pythonflask',
        passwd = '123456',
        db = 'test',
        charset = 'utf8',
        autocommit=True
        )
        self.conn=conn
        self.cursor = self.conn.cursor()
        return conn
    def excute(self,sql):
        a=self.cursor.execute(sql)
        print(a)
    def has_usrname(self,usrname):
        
        sql="select count(usrname) from userinfo where usrname=\"{}\"".format(usrname)
        print(sql)
        self.excute(sql)
        ans=self.cursor.fetchone()[0]
        print(ans)
        return ans
    def close(self):
        self.cursor.close()
        self.conn.close()
