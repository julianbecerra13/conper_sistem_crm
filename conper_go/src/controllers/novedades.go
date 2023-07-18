package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type NovedadesRequest struct {
	IDUsuario string `json:"idUsuario"`
	IDPunto   string `json:"idPunto"`
	
}

func Novedades(c *gin.Context) {
	var novedadesRequest NovedadesRequest
	var novedadesResponse []models.Novedades

	// Capturar los parametros de la url
	novedadesRequest.IDUsuario = c.Query("idUsuario")
	novedadesRequest.IDPunto = c.Query("idPunto")
	
	result := db.Raw("CALL spcp_sil_novedades(?, ?)", novedadesRequest.IDUsuario, novedadesRequest.IDPunto).Scan(&novedadesResponse)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"novedades": novedadesResponse})
}