package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type PqrsRequest struct {
	IDNivel string `json:"nivel"`
	IDPunto string `json:"idPunto"`
	
}

func Pqrs(c *gin.Context) {
	var pqrsRequest PqrsRequest
	var pqrsResponse []models.Pqrs

	// Capturar los parametros de la url
	pqrsRequest.IDNivel = c.Query("idNivel")
	pqrsRequest.IDPunto = c.Query("idPunto")
	
	result := db.Raw("CALL spcp_sil_pqrpunto(?, ?)", pqrsRequest.IDNivel, pqrsRequest.IDPunto).Scan(&pqrsResponse)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"Pqrs": pqrsResponse})
}