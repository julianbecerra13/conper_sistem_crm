package controllers

import (
	"crypto/sha256"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/myperri/copner/src/config"
	"github.com/myperri/copner/src/models"
	"gorm.io/gorm"
)

var db *gorm.DB = config.ConnectDB()

type UsuarioRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func Login(c *gin.Context) {

	var usuario UsuarioRequest
	var usuarioResponse models.Usuario

	// Bind request body to struct
	if err := c.ShouldBindJSON(&usuario); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// hash password
	hash := sha256.Sum256([]byte(usuario.Password))
	hashHex := fmt.Sprintf("%x", hash)

	// query
	result := db.Table("tcpc_loginusuarios").First(&usuarioResponse, "usuario = ? AND clave = ?", usuario.Username, hashHex)
	if result.Error != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Usuario o contraseña incorrectos"})
		return
	}
	fmt.Println("Usuario:", usuario.Username, "Contraseña:", usuario.Password)

	// retorna la respuesta
	c.JSON(http.StatusOK, usuarioResponse)

}
