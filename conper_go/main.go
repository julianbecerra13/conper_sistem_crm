package main

import (
	"fmt"

	"github.com/myperri/copner/src/config"
	"github.com/myperri/copner/src/routes"
	"gorm.io/gorm"
)

var (
	db *gorm.DB = config.ConnectDB()
)

func main() {
	defer config.DissconnectDB(db)

	fmt.Println("Arrancando el servidor...")
	// run all routes
	routes.Routes()
}
