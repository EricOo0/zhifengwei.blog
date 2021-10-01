package main
import (
	"io"
      "log"
      "net"
      "os"
	"fmt"
	  )

func main() {
      conn, err := net.Dial("tcp", "43.132.117.118:8000")
      if err != nil {
          log.Fatal(err)
      }
      defer conn.Close()
      go mustCopy(os.Stdout, conn)
      mustCopy(conn,os.Stdin)
	  fmt.Println("asd")
}
func mustCopy(dst io.Writer, src io.Reader) {
      if _, err := io.Copy(dst, src); err != nil {
          log.Fatal(err)}
	  fmt.Println("asd")
}
