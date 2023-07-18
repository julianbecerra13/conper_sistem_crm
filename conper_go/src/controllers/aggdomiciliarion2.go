package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AggDomiciliariosn2Request struct {
	Nivel string `json:"nivel"`
	Cedula string `json:"cedula"`
	Nombre string `json:"nombre"`
	Telefono string `json:"telefono"`
	IdPunto int `json:"idPunto"`
}

func AggDomiciliariosn2(c *gin.Context) {
	var aggdomiciliariosn2Request AggDomiciliariosn2Request

	if err := c.ShouldBindJSON(&aggdomiciliariosn2Request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := db.Exec("CALL spcp_sil_buscacreamovil(?,?,?,?,?)", aggdomiciliariosn2Request.Nivel, aggdomiciliariosn2Request.Cedula, aggdomiciliariosn2Request.Nombre, aggdomiciliariosn2Request.Telefono, aggdomiciliariosn2Request.IdPunto)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"actualizado": true})
}
