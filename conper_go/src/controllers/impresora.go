package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type ImpresoraRequest struct {
	IdPunto        int    `json:"idPunto"`
}

func Impresora(c *gin.Context) {
	var impresoraRequest ImpresoraRequest

	if err := c.ShouldBindJSON(&impresoraRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := db.Exec("call spcp_impresion_check1(?,?)", impresoraRequest.IdPunto, "1")

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"actualizado": true})
}