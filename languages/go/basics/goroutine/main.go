package main

import "fmt"

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

// func main() {
// 	ch := make(chan int)
// 	go func(ch chan int) {
// 		for v := range ch {
// 			fmt.Println("value", v)
// 		}
// 	}(ch)

// 	for i := range 10 {
// 		ch <- i
// 	}
// 	close(ch)
// 	fmt.Println("发送成功")
// }

// func main() {
// 	ch1 := make(chan int)
// 	ch2 := make(chan int)

// 	go func() {
// 		// ch1 <- 1
// 	}()

// 	go func(ch2 chan int) {
// 		ch2 <- 1
// 		close(ch2)
// 	}(ch2)

// 	select {
// 	case v := <-ch1:
// 		fmt.Println("ch1", v)
// 	case <- time.After(3 * time.Second):
// 		fmt.Println("超时！")
// 	}

// }

// func main() {
// 	ch := make(chan int, 1)
// 	for i := 1; i <= 10; i++ {
// 		select {
// 		case x := <-ch:
// 			fmt.Println(x)
// 		case ch <- i:
// 		}
// 	}
// }

// var (
// 	i  int
// 	wg sync.WaitGroup
// 	mu sync.Mutex
// )

// func add(mu *sync.Mutex) {
// 	defer wg.Done()

// 	l := 0
// 	for range 5000 {
// 		l++
// 	}

// 	mu.Lock()
// 	i += l
// 	mu.Unlock()

// }

// func main() {

// 	l := 0
// 	for range 10 {
// 		fmt.Println("v", l)
// 		l++
// 	}

// 	wg.Add(2)
// 	go add(&mu)
// 	go add(&mu)
// 	wg.Wait()
// 	fmt.Println("i", i)
// 	fmt.Println("v", l)
// }

// func worker(ctx context.Context) {
// 	for {
// 		select {
// 		case <-ctx.Done(): // 监听取消信号
// 			fmt.Println("worker stopped")
// 			return
// 		default:
// 			fmt.Println("working...")
// 			time.Sleep(500 * time.Millisecond)
// 		}
// 	}
// }

// func main() {
// 	ctx, cancel := context.WithCancel(context.Background())
// 	go worker(ctx)
// 	go worker(ctx)
// 	time.Sleep(3 * time.Second)
// 	cancel() // 触发取消
// 	time.Sleep(200 * time.Millisecond) // 等待 worker 退出
// }
// 



func ech(s []int) {
	fmt.Printf("dzzz %p\n", &s)
	for k, v := range s {
		s[k] = v * v
		fmt.Println(v)
	}
}

func main() {
	s := []int{1, 2, 3}
	ech(s)
	fmt.Printf("mmmm %p\n", &s)
	fmt.Println("vvvv", s)
}
