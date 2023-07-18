package controllers

import (
	"net/http"
	"github.com/gin-gonic/gin"
)

type ActualizadorRequest struct {
	IdPunto        int    `json:"idPunto"`
	IdPedido       int    `json:"idPedido"`
	IdTraza        int `json:"idTraza"`
	IdDomiciliario int    `json:"idDomiciliario"`
}

func Actualizar(c *gin.Context) {
	var actualizadorRequest ActualizadorRequest

	if err := c.ShouldBindJSON(&actualizadorRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := db.Exec("CALL spcp_sil_creatraza_motorizado(?, ?, ?, ?, ?, ?, ?)", actualizadorRequest.IdPunto, actualizadorRequest.IdPedido, "1", "1", actualizadorRequest.IdTraza, "", actualizadorRequest.IdDomiciliario)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"actualizado": true})
}
