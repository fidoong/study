package main

import (
	"fmt"
	"viper_demo/bootstrap"
	"viper_demo/global"
)

func main() {
	bootstrap.InitializeConfig()
	fmt.Println("Traffic Service Started...!")

	var globalCong = global.App.Conf
	fmt.Printf("globalCong: %+v\n", globalCong)
	fmt.Printf("DBName: %+v\n", globalCong.MySQL.DBName)
	var customCong = global.App.Custom
	fmt.Printf("customCong: %+v\n", customCong)
}
