package main

import "fmt"

func main() {
	b :=Bird{
		Name: "foo",
		Age: 15,
	}
	b.Sing()
	fmt.Println("test")
}

type Singer interface {
	Sing()
}

type Bird struct {
	Name string
	Age  int
}

func (b Bird) Sing() {
	fmt.Print("Bird\v%", b.Age)
	fmt.Print("Bird\v%", b.Name)
}
