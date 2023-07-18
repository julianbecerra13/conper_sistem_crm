package routes

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/controllers"
)

func Routes() {
	route := gin.Default()
	route.Use(cors.Default())

	route.POST("/login", controllers.Login)
	route.PUT("/actualizar", controllers.Actualizar)
	route.PUT("/actualizarT", controllers.ActualizarT)
	route.GET("/pedidos", controllers.Pedidos)
	route.GET("/domicilios", controllers.Domicilios)
	route.GET("/domiciliarios", controllers.Domiciliarios)
	route.GET("/novedades", controllers.Novedades)
	route.PUT("/aggdomiciliarios", controllers.AggDomiciliarios)
	route.PUT("/aggdomiciliariosn2", controllers.AggDomiciliariosn2)
	route.PUT("/detalles", controllers.Detalles)
	route.PUT("/impresora", controllers.Impresora)
	route.PUT("/aggnovedad1", controllers.AggNovedad)
	route.PUT("/archivopost", controllers.GenerarArchivoPO1)
	route.GET("/pqrs", controllers.Pqrs)
	route.PUT("/respuestaPqrs", controllers.RespuestaPqrs)
	route.GET("/cuadrecajadomi", controllers.CuadreCajaDomi)
	route.GET("/cuadrecajapunto", controllers.CuadreCajaPunto)


	route.Run()
}
