package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type PedidosRequest struct {
	IDCliente string `json:"idPedido"`
	IDTraza   string `json:"nombreCliente"`
	IDPunto   string `json:"direccionOrden"`
}

func Pedidos(c *gin.Context) {
	var pedidosRequest PedidosRequest
	var pedidosResponse []models.Pedidos

	// Capturar los parametros de la url
	pedidosRequest.IDCliente = c.Query("idCliente")
	pedidosRequest.IDTraza = c.Query("idTraza")
	pedidosRequest.IDPunto = c.Query("idPunto")

	result := db.Raw("CALL spcp_sil_trazastotal(?, ?, ?)", pedidosRequest.IDCliente, pedidosRequest.IDTraza, pedidosRequest.IDPunto).Scan(&pedidosResponse)
	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ordenes": pedidosResponse})

}
