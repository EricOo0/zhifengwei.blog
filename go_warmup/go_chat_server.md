# 聊天服务

聊天室--server

```go
package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
)

func main() {
	listener, err := net.Listen("tcp", "0.0.0.0:8000") //监听本地 8000端口
	if err != nil {
		log.Fatal(err)
	}
	go broadcaster()  //开启一个广播的线程负责转发消息
	for {
		conn, err := listener.Accept()  //循环接收消息
		if err != nil {
			log.Print(err)
			continue
		}
		go handleConn(conn)
	}
}

type client chan<- string // an outgoing message channel 只进不出的单向channel
var (
	entering = make(chan client)  //entering 是一个双向chan ；传递的变量是一个单向可写chan
	leaving  = make(chan client)
	messages = make(chan string) // all incoming client messages
)
func broadcaster() {
	clients := make(map[client]bool) // all connected clients 用于保存所有客户端链接
	for {
		select {
		case msg := <-messages: //消息可读
			// Broadcast incoming message to all
			// clients' outgoing message channels.
			for cli := range clients {//遍历所有clients 发送消息
				cli <- msg
			}
		case cli := <-entering:  //客户端进入
			clients[cli] = true
		case cli := <-leaving:  // 客户端离开
			delete(clients, cli)  //删除切关闭这个链接
			close(cli)
		}
	}
}

func handleConn(conn net.Conn) {
	ch := make(chan string) // outgoing client messages
	go clientWriter(conn, ch)
	who := conn.RemoteAddr().String() //提取连接对方的地址
	ch <- "You are " + who
	messages <- who + " has arrived"
	entering <- ch
	input := bufio.NewScanner(conn)
	for input.Scan() {
		messages <- who + ": " + input.Text()
	}
	// NOTE: ignoring potential errors from input.Err()
	//处理完离开
	leaving <- ch
	messages <- who + " has left"
	conn.Close()
}
func clientWriter(conn net.Conn, ch <-chan string) {
	for msg := range ch {
		fmt.Fprintln(conn, msg) // NOTE: ignoring network errors
	}
}

```

server 一共有4个go routine

1、main：创建服务器，for死循环监听是否有连接需要accept

2、broadcaster线程：创建了一个clients的map 来保存所有已建立的客户端；通过select的io复用，执行：

​	2.1、有消息可读；把这条消息转发给所有client

​	2.2、有新用户进入：加入到clients的map中

​	2.3、有用户离开：从clients 的map中删除并关闭连接

3、handleConn：每一个新来的连接都会新建一个 go routine，负责把消息传到对应线程中去

4、clientWriter：每一个新来的连接都会有一个clientWriter，负责把消息发送给客户端

n个客户端，一共会有2n+2个go routine



客户端 -- 简单的连接到服务器即可

```go
package main
import (
   "io"
      "log"
      "net"
      "os"
   "fmt"
     )

func main() {
      conn, err := net.Dial("tcp", "localhost:8000")
      if err != nil {
          log.Fatal(err)
      }
      defer conn.Close()
      go mustCopy(os.Stdout, conn)
      mustCopy(conn,os.Stdin)
    
}
func mustCopy(dst io.Writer, src io.Reader) {
      if _, err := io.Copy(dst, src); err != nil {
          log.Fatal(err)}
}
```

