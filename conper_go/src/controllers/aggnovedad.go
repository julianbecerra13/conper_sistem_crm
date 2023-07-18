package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AggNovedadRequest struct {
	Level     int    `json:"level"`
	IdPunto   int    `json:"idPunto"`
	IdNovedad int    `json:"idNovedad"`
	Novedad   string `json:"novedad"`
	IdCliente int    `json:"idCliente"`
	Idcp      int    `json:"idcp"`
	Activo    int    `json:"activo"`
}

func AggNovedad(c *gin.Context) {
	var aggNovedadRequest AggNovedadRequest

	if err := c.ShouldBindJSON(&aggNovedadRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := db.Exec("call spcp_sil_creanovedades(?, ?, ?, ?, ?, ?, ?)", aggNovedadRequest.Level, aggNovedadRequest.IdPunto, aggNovedadRequest.IdNovedad, aggNovedadRequest.Novedad, aggNovedadRequest.IdCliente, aggNovedadRequest.Idcp, aggNovedadRequest.Activo)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"actualizado": true})
}
