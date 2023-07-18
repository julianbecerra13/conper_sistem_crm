package controllers

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/models"
)

type GenerarArchivoPO1Request struct {
	FechaInicio string `json:"fechaInicio"`
	IDPunto     int    `json:"idPunto"`
}

func GenerarArchivoPO1(c *gin.Context) {
	var request GenerarArchivoPO1Request
	var resultados []models.Result

	// Leer los parámetros de la solicitud JSON
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Ejecutar el procedimiento almacenado
	result := db.Raw("CALL spcp_sil_posarchivopunto(?, ?)", request.FechaInicio, request.IDPunto).Scan(&resultados)
	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": result.Error.Error()})
		return
	}

	// Verificar si se obtuvieron resultados
	if len(resultados) == 0 {
		c.JSON(http.StatusOK, gin.H{"mensaje": "No se encontraron resultados para los parámetros especificados"})
		return
	}

	// Obtener la fecha actual
	year, month, day := time.Now().Date()

	// Construir el nombre del archivo
	nombreArchivo := "P" + strconv.Itoa(request.IDPunto) + strconv.Itoa(year%10) + strconv.Itoa(int(month)) + strconv.Itoa(day) + ".PO1"

	// Obtener la ruta personalizada donde se almacenará el archivo .PO1
	rutaPersonalizada := "C:\\Users\\becer\\OneDrive\\Documentos\\archivosPOST"

	// Construir la ruta completa del archivo .PO1
	rutaArchivo := filepath.Join(rutaPersonalizada, nombreArchivo)

	// Construir el contenido del archivo .PO1
	var contenidoArchivo strings.Builder
	for _, resultado := range resultados {
		contenidoArchivo.WriteString(resultado.Archivo)
		contenidoArchivo.WriteString("\n")
	}

	// Guardar el contenido en un archivo .PO1
	err := ioutil.WriteFile(rutaArchivo, []byte(contenidoArchivo.String()), 0644)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"archivo": nombreArchivo})
}
