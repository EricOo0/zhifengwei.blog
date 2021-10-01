package main

import (
	"fmt"
	"log"
	"net/rpc"
)
type Args struct {
	A, B int
}
type MathService struct {

}
func main() {
	var serverAddress = "localhost"                           //rpc服务器的ip
	client, err := rpc.DialHTTP("tcp", serverAddress+":9999") //建立与指定 IP 地址和端口的 RPC 服务器
	if err != nil {
		log.Fatal("建立与服务端连接失败:", err)
	}
	args := &Args{10, 10}
	var reply int
	err = client.Call("MathService.Multiply", args, &reply) //Call 方法实现同步调用
	if err != nil {
		log.Fatal("调用远程方法 MathService.Multiply 失败:", err)
	}
	fmt.Printf("%d*%d=%d\n", args.A, args.B, reply)
	secondCall := client.Go("MathService.Multiply", args, &reply, nil) //Go方法实现异步调用；nil传入一个用于标识调用是否完成的通道参数
	for {                                                              //死循环
		select { //select 是 Go 中的一个控制结构，类似于用于通信的 switch 语句。每个 case 必须是一个通信操作，要么是发送要么是接收。select 随机执行一个可运行的 case --io多路复用？
		case <-secondCall.Done: //接受操作
			fmt.Printf("%d*%d=%d\n", args.A, args.B, reply)
			return
		}
	}
}