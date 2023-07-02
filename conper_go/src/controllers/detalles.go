package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)
type DetallesRequest struct {
	IdPedido int `json:"idPedido"`
}
func Detalles(c *gin.Context) {
	var detallesRequest DetallesRequest
	var detallesResponse []models.Detalles

	if err := c.ShouldBindJSON(&detallesRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	result := db.Raw("CALL spcp_sil_detallepedido(?)", detallesRequest.IdPedido).Scan(&detallesResponse)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"detalles": detallesResponse})
}