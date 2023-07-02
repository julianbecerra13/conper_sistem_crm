package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type DomiciliosRequest struct {
	IDCliente string `json:"idPedido"`
	IDTraza   string `json:"nombreCliente"`
	IDPunto   string `json:"direccionOrden"`
}

func Domicilios(c *gin.Context) {
	var domiciliosRequest DomiciliosRequest
	var domiciliosResponse []models.Domicilios

	// Capturar los parametros de la url
	domiciliosRequest.IDCliente = c.Query("idCliente")
	domiciliosRequest.IDTraza = c.Query("idTraza")
	domiciliosRequest.IDPunto = c.Query("idPunto")

	result := db.Raw("CALL spcp_sil_trazastotal(?, ?, ?)", domiciliosRequest.IDCliente, domiciliosRequest.IDTraza, domiciliosRequest.IDPunto).Scan(&domiciliosResponse)
	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"ordenes": domiciliosResponse})

}
