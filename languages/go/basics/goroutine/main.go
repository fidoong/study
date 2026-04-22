package main

import (
	"fmt"
	"sync"
	"time"
)

var wg sync.WaitGroup

// func main() {
// 	for i := range 10 {
// 		wg.Add(1)
// 		go Hello(i)
// 	}

// 	wg.Wait()

// }

// func Hello(i int) {
// 	defer wg.Done()
// 	fmt.Printf("Hello %d\n", i)
// }

// func main() {
// 	ch := make(chan int)

// 	go func(ch chan int) {
// 		ret := <- ch
// 		fmt.Println("vvvvv",ret)
// 	}(ch)

// 	ch <- 10

// }

// func pf(ch chan int) {
// 	num := 0
// 	for {
// 		num++
// 		v, ok := <-ch
// 		fmt.Println("num", num)

// 		if !ok {
// 			fmt.Println("channel closed")
// 			break
// 		}

// 		fmt.Println("value", v)
// 		fmt.Printf("v:%#v ok:%#v\n", v, ok)
// 	}
// }

// func pf3(ch chan int) {
// 	num := 0
// 	for v := range ch {  // 自动处理关闭，读完后退出
// 		num++
// 		fmt.Println("num", num)
// 		fmt.Println("value", v)
// 	}
// 	fmt.Println("channel closed")
// }

// func main() {
// 	ch := make(chan int, 2)
// 	ch <- 10
// 	ch <- 20
// 	close(ch)
// 	pf3(ch)
// }

// 生产者

// func Producer() chan int {

// 	ch := make(chan int, 1)

// 	go func() {
// 		for v := range 10000000 {
// 			if v%2 == 1 {
// 				ch <- v
// 			}
// 		}
// 		close(ch)
// 	}()

// 	return ch
// }
// // 消费者
// func Consumer(ch chan int) int {
// 	sum := 0
// 	for v := range ch {
// 		fmt.Println("value", v)
// 		sum += v
// 	}
// 	return sum
// }

// func main() {
// 	t1 := time.Now()
// 	ch := Producer()
// 	v := Consumer(ch)
// 	fmt.Println("time", time.Since(t1))
// 	fmt.Println("sum", v)
// }


func main() {
	
}