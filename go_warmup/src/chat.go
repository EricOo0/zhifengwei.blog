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
	//处理完就离开
	leaving <- ch
	messages <- who + " has left"
	conn.Close()
}
func clientWriter(conn net.Conn, ch <-chan string) {
	for msg := range ch {
		fmt.Fprintln(conn, msg) // NOTE: ignoring network errors
	}
}
