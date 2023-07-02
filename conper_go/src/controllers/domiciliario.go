package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type DomiciliariosRequest struct {
	IDCliente string
	IDTraza   string
}

func Domiciliarios(c *gin.Context) {
	var domiciliariosRequest DomiciliariosRequest
	var domiciliariosResponse []models.Domiciliarios

	// Capturar los parametros de la url
	domiciliariosRequest.IDCliente = c.Query("idCliente")
	domiciliariosRequest.IDTraza = c.Query("idTraza")

	result := db.Raw("CALL spcp_sil_movil(?, ?)", domiciliariosRequest.IDCliente, domiciliariosRequest.IDTraza).Scan(&domiciliariosResponse)
	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"domiciliarios": domiciliariosResponse})
}
