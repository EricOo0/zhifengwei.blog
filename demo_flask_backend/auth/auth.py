from db.db import DB_con
class Auth:
    def __init__(self,usrname):
        self.usrname=usrname
    def usr_auth(self):
     
        DB=DB_con()
        DB.connect()
        ret=DB.has_usrname(self.usrname)
        DB.close()
        return ret
        
        