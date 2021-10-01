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