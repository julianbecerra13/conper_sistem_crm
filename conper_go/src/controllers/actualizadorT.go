package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type ActualizadorTRequest struct {
	IdPunto        int    `json:"idPunto"`
	IdPedido       int    `json:"idPedido"`
	IdTraza        int `json:"idTraza"`
	Idincidente   int    `json:"idincidente"`
}

func ActualizarT(c *gin.Context) {
	var actualizadorTRequest ActualizadorTRequest

	if err := c.ShouldBindJSON(&actualizadorTRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := db.Exec("CALL spcp_sil_creatraza(?, ?, ?, ?, ?, ?)", actualizadorTRequest.IdPunto, actualizadorTRequest.IdPedido, "1", actualizadorTRequest.Idincidente, actualizadorTRequest.IdTraza, "")

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"actualizado": true})
}
