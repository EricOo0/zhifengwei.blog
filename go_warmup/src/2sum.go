package main

import "fmt"

func main()  {
	hashTable :=map[int] int{}
	hashTable[1]=11
	hashTable[2]=21
	//target:=0
	if p,ok := hashTable[1];ok{
		fmt.Println("123123123\n")
		fmt.Println(p,ok)
	}
	fmt.Println("done")

}
