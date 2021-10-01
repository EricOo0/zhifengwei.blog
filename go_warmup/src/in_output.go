package main
import (
	"bufio"
	"fmt"
	"os"
)
func main(){
	input := bufio.NewScanner(os.Stdin)//new 一个io输入,扫描标准输入
	counts := make(map[string]int)
	input.Scan()//放到buffer
	str1 :=input.Text()//从buffer出来
	fmt.Println(str1)
	for input.Scan(){
		counts[input.Text()]++//crtl+d 结束循环
	}
	for line,n :=range counts{
		fmt.Printf("line:%s,counts:%d\n",line,n)
	}
}
