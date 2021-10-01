package main

import (
	"log"
	"net/http" //http的包
	"fmt"
)


func  main()  {
	http.HandleFunc("/",HelloServer)//设置路由
	err := http.ListenAndServe(":8080", nil)
	if err != nil{
		log.Fatal("ListenAndServe:",err)
	}

}

func HelloServer(w http.ResponseWriter, r *http.Request){
	r.ParseForm()  //解析参数，默认是不会解析
	fmt.Println(r.Form)
	fmt.Println(r.URL.Path)
	fmt.Println("host", r.Host)
	fmt.Println(r.Form["usrname"])
	client := r.UserAgent()
	fmt.Fprintf(w, "Hello client!%s",client)

}