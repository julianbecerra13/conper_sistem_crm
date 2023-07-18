package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type CuadreCajaRequest struct {
	IDpunto        string `json:"idPunto"`
	FechaInicio    string `json:"fechaInicio"`
	FechaFin       string `json:"fechaFin"`
}

func CuadreCajaDomi(c *gin.Context) {

	var cuadreCajaRequest CuadreCajaRequest
	var cuadreCaja []models.CuadreCaja

	//capturar los parametros dela url
	cuadreCajaRequest.IDpunto = c.Query("idPunto")
	cuadreCajaRequest.FechaInicio = c.Query("fechaInicio")
	cuadreCajaRequest.FechaFin = c.Query("fechaFin")

	result := db.Raw("call spcp_sil_cuadrecajamovil(?,?,?)", cuadreCajaRequest.IDpunto, cuadreCajaRequest.FechaInicio, cuadreCajaRequest.FechaFin).Scan(&cuadreCaja)

	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"cuadreCaja": cuadreCaja})
}
