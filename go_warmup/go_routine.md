# 并发



#### Goroutines

在Go语言中，每一个并发的执行单元叫作一个goroutine。（协程）

* 关键字go用来创建go协程： go func( )

* 主函数返回时，所有的goroutine都会被直接打断，程序退出
* 没有其它的编程方法能够让一个goroutine来打断另一个的执行

**example 1:**

clock.go

```go
package main
import (
   "io"
   "log"
   "net"
   "time"
)
func main() {
   listener, err := net.Listen("tcp", "localhost:8000") // create a listener to licten to port 8000
   if err != nil {
      log.Fatal(err)
   }
   for {
      conn, err := listener.Accept() //block here until accept a connection
      if err != nil {
         log.Print(err) // e.g., connection aborted
         continue }
      go handleConn(conn) // go will create a goroutine so that can handle many connection
   }
}
func handleConn(c net.Conn) {
   defer c.Close() //exacuate close after handleConn finished
   for {
      _, err := io.WriteString(c, time.Now().Format("15:04:05\n"))  //reponse time to client and client will keep print time
      if err != nil {
         return // e.g., client disconnected
      }
      time.Sleep(1 * time.Second)
   }
}
```

![image-20210929164122529](/Users/weizhifeng/Library/Application Support/typora-user-images/image-20210929164122529.png)

通过go创建出来的协程直接互不干扰，如果不使用go，需要等一个客户端断开连接后才会接受下一个链接

**example 2:**

echo.go --server

```go
package main
import (
   "bufio"
   "fmt"
   "log"
   "net"
   "strings"
   "time"
)
func main() {
   listener, err := net.Listen("tcp", "localhost:8000") // create a listener to licten to port 8000
   if err != nil {
      log.Fatal(err)
   }
   for {
      conn, err := listener.Accept() 
      if err != nil {
         log.Print(err) // e.g., connection aborted
         continue }
      go handleConn(conn) // 
   }
}
func echo(c net.Conn, shout string, delay time.Duration) {
   fmt.Fprintln(c, "\t", strings.ToUpper(shout))
   time.Sleep(delay)
   fmt.Fprintln(c, "\t", shout)
   time.Sleep(delay)
   fmt.Fprintln(c, "\t", strings.ToLower(shout))
}
func handleConn(c net.Conn) {
   input := bufio.NewScanner(c)
   for input.Scan() {
      go echo(c, input.Text(), 1*time.Second)
   }
   // NOTE: ignoring potential errors from input.Err()
   c.Close() }
```

Client.go

```go
package main
import ( 
			"io"
      "log"
      "net"
      "os"
)

func main() {
      conn, err := net.Dial("tcp", "localhost:8000")
      if err != nil {
          log.Fatal(err)
      }
      defer conn.Close()
      go mustCopy(os.Stdout, conn)//将conn中的服务器的回复 复制 到标准输出 --echo
      mustCopy(conn, os.Stdin)//在终端手动输入信息，copy到conn中
}
func mustCopy(dst io.Writer, src io.Reader) {
      if _, err := io.Copy(dst, src); err != nil {
          log.Fatal(err)}
}
```



#### channels

Channels 通道，goroutine之间的通信机制，可以让一个goroutine通过它给另一个goroutine发送值信息。

创建channel：

```go
ch := make(chan int) // ch has type 'chan int'
```

无缓存的channels

​	无缓存Channels 有时候也被称为同步Channels，如果一个goroutine在另一个发送之前进行接受操作，则会阻塞在接收过程

单方向的channels

​	out  chan<- int 表示一个只发送int的channel，只能发送不能接收

​	in <-chan int 表示一个只接收int的channel，只能接收不能发送。

带缓存的channels

​	带缓存的Channel内部持有一个元素队列。队列的最大容量是在调用make函数创建channel时通过第二个参数指 定的。

```go
ch = make(chan string, 3)
```

