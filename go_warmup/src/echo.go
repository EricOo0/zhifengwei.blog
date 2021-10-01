package main

import (
	"fmt"
	"os"
	"strings"

)

func main() {
	//rand.Seed(11)
	//fmt.Println("random number is ",rand.Intn(15))
	//for_loop(3,2);
	str := ""
	str2:=strings.Join(os.Args[1:]," ")
	name :=os.Args[0]
	for i := 1; i < len(os.Args); i++ {
		str += os.Args[i]
		str += " "
	}
	fmt.Println(name)
	fmt.Println(str)
	fmt.Println(str2)
}
