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

go实现 du工具

```go
package main
import (
   "flag"
   "fmt"
   "io/ioutil"
   "os"
   "path/filepath"
   "time"
)
var done = make(chan struct{})
var verbose = flag.Bool("v", false, "show verbose progress messages") //增加一个命令行参数 v
func cancelled() bool {
   select {
   case <-done:
      return true
   default:
      return false
   } }

func main() {
   // Determine the initial directories.
   flag.Parse() // flag 包实现了命令行参数的解 os.Arg也可以获取参数
   roots := flag.Args()
   if len(roots) == 0 {
      roots = []string{"."}
   }
   // Traverse the file tree.
   fileSizes := make(chan int64)  //创建一个文件大小的通道
   go func() {
      for _, root := range roots { //遍历roots路径下的所有文件夹，调用walkDir去递归遍历
         walkDir(root, fileSizes)
      }
      close(fileSizes)  //遍历完关闭通道
   }()
   // Print the results.
   var tick <-chan time.Time
   if *verbose {
      tick = time.Tick(500 * time.Millisecond)
   }
   var nfiles, nbytes int64
loop:
   for {
      select {
      case size, ok := <-fileSizes:
         if !ok {
            break loop // fileSizes was closed
         }
         nfiles++
         nbytes += size
      case <-tick:
         printDiskUsage(nfiles, nbytes)
      }
   }
   printDiskUsage(nfiles, nbytes) // final totals
}
func printDiskUsage(nfiles, nbytes int64) {
   fmt.Printf("%d files  %.1f GB\n", nfiles, float64(nbytes)/1e9)
}
// walkDir recursively walks the file tree rooted at dir
// and sends the size of each found file on fileSizes.
func walkDir(dir string, fileSizes chan<- int64) {
   for _, entry := range dirents(dir) {
      if entry.IsDir() { //是文件夹就递归
         subdir := filepath.Join(dir, entry.Name())
         walkDir(subdir, fileSizes)
      }else {
         fileSizes <- entry.Size()//是文件就放入通道
      }
   }
}
// dirents returns the entries of directory dir.

func dirents(dir string) []os.FileInfo {
   entries, err := ioutil.ReadDir(dir) //读取当前文件夹下所有文件和文件夹
   if err != nil {
      fmt.Fprintf(os.Stderr, "du1: %v\n", err)
      return nil }
   return entries
}
```

1 #! /bin/bash
  2 #ssh liqi@10.89.11.240
  3 #ssh s121md209_06@dl2080-09.dynip.ntu.edu.sg
  4 #6M!s@c#0916
  5 if [ $# == 1 ]
  6 then
  7     echo "22"
  8     if [ $1 == 1]
  9     then
 10         echo 'ssh liqi@10.89.11.240'
 11         ssh liqi@10.89.11.240
 12     else if [ $1 == 2 ]
 13     then
 14         echo 'ssh s121md209_06@dl2080-09.dynip.ntu.edu.sg'
 15         ssh s121md209_06@dl2080-09.dynip.ntu.edu.sg
 16     else if [ $1 == 3 ]
 17     then
 18         echo 'ssh root@43.132.117.118'
 19         ssh root@43.132.117.118
 20     fi
 21 fi