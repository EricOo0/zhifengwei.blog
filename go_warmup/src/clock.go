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
		conn, err := listener.Accept() //block here until accept a connection
		if err != nil {
			log.Print(err) // e.g., connection aborted
			continue }
		go handleConn(conn) // handle one connection at a time
	}
}
/*
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
*/

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