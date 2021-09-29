# Go rpc编程

RPC（Remote Procedure Call，远程过程调用）是一种通过网络请求从远程服务器调用服务，而不需要了解底层网络细节的应用程序通信协议。基于传输层的 TCP 或 UDP 协议，或者是应用层的 HTTP 协议构建，允许开发者直接调用另一台计算机上的程序，而开发者无需额外地为这个调用过程编写网络通信相关代码。微服务就是基于RPC。

* 包：

  net/rpc --实现了rpc协议的细节

* 方法：

  #### 服务端：

  ```go
  func (t *T) MethodName(argType T1, replyType *T2) error
  ```

  T 是服务对象的类型；T1是服务调用者的类型；T2是响应/返回类型

  例：

  ```go
  package main
  import (
   
    "net"
    "net/http"
     "net/rpc"
    "log"
  )
  
  type Args struct {
    A, B int
  }
  type MathService struct {
    
  }
  func (m *MathService) Multiply(args *Args, reply *int) error {
    *reply = args.A * args.B
    return nil
  }
  func main() {
      // 启动 RPC 服务端
    math := new(MathService)
    rpc.Register(math) //注册MathService的一个对象到服务端
    rpc.HandleHTTP()//服务端为http服务器
    listener, err := net.Listen("tcp", ":9999")
    if err != nil {
      log.Fatal("启动服务监听失败:", err)
    }
    err = http.Serve(listener, nil)//启动http服务器
    if err != nil {
      log.Fatal("启动 HTTP 服务失败:", err)
    }
  }
  ```

  #### 客户端：

  先要建立连接

  ```go
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
  func main()  {
    var serverAddress = "localhost"//rpc服务器的ip
    client, err := rpc.DialHTTP("tcp", serverAddress + ":9999")//建立与指定 IP 地址和端口的 RPC 服务器
    if err != nil {
      log.Fatal("建立与服务端连接失败:", err)
    }
    args := &Args{10,10}
    var reply int
  	err = client.Call("MathService.Multiply", args, &reply)//Call 方法实现同步调用
    if err != nil {
      log.Fatal("调用远程方法 MathService.Multiply 失败:", err)
    }
    fmt.Printf("%d*%d=%d\n", args.A, args.B, reply)
    secondCall := client.Go("MathService.Multiply", args, &reply, nil)//Go方法实现异步调用；nil传入一个用于标识调用是否完成的通道参数
    for {//死循环
      select {//select 是 Go 中的一个控制结构，类似于用于通信的 switch 语句。每个 case 必须是一个通信操作，要么是发送要么是接收。select 随机执行一个可运行的 case --io多路复用？
      case <-secondCall.Done://接受操作
        fmt.Printf("%d/%d=%d\n", args.A, args.B, reply)
        return
      }
  	}
  }
  ```

  ​	









