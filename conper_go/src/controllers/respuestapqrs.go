package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type RespuestaPqrsRequest struct {
	IDpQRS int `json:"idPqrs"`
	Respuesta string `json:"respuesta"`
	IDUsuario int `json:"idUsuario"`
}

func RespuestaPqrs(c *gin.Context) {
	var respuestaPqrsRequest RespuestaPqrsRequest

	if err := c.ShouldBindJSON(&respuestaPqrsRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	result := db.Exec("call spcp_sil_pqrcierrepunto(?, ?, ?)", respuestaPqrsRequest.IDpQRS, respuestaPqrsRequest.Respuesta, respuestaPqrsRequest.IDUsuario)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"actualizado": true})
}