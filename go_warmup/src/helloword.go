package main2
import "fmt"
func main2(){
	fmt.Println("hello world!")
	//变量命名--先用var 声明 类型
	var name int8
	name=1
	// 批量声明  go里面声明了必须使用
	var (
		name2 int8
		name3 string

	)
	name2 = 10
	name3="abc"
	fmt.Println(name)//带换行

	fmt.Print(name2)
	fmt.Printf("name:%s",name3)


}