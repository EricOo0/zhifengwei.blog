package main

import (
	"fmt"
	//"math/rand"
	//"os"
)

func add(x int,y int) int {
	return x+y

}
func for_loop(x,y int) int{
	for i:=0;i<x;i++{
		fmt.Printf("%d\n",y)
	}
	return 1
}
func main(){
	//rand.Seed(11)
	//fmt.Println("random number is ",rand.Intn(15))
	//for_loop(3,2);
	//for i:=0;i<len(os.Args);i++{
//		fmt.Println(os.Args[i])
//	}
	s := "abc"
	fmt.Println(&s)
	slice :=[]byte(s)
	fmt.Println(&slice)
	fmt.Printf("add:%p\n",slice)
	s_copy :=string(slice)
	slice[0]='1'
	fmt.Println(slice)
	fmt.Printf("add:%p\n",slice)
	fmt.Println(s_copy)
}
