package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type AggDomiciliariosRequest struct {
	Cedula string `json:"cedula"`
}

func AggDomiciliarios(c *gin.Context) {
	var aggdomiciliariosRequest AggDomiciliariosRequest
	var aggdomiciliarioResponse []models.AggDomiciliarios

	if err := c.ShouldBindJSON(&aggdomiciliariosRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := db.Raw("CALL spcp_sil_buscacreamovil(?,?,?,?,?)", "1", aggdomiciliariosRequest.Cedula, "", "", "0").Scan(&aggdomiciliarioResponse)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"domiciliarios": aggdomiciliarioResponse})
}
