package models

type Usuario struct {
	Nombre         string `gorm:"column:nombre"`
	Usuario        string `gorm:"column:usuario"`
	Celular        string `gorm:"column:celular"`
	Identificacion string `gorm:"column:identificacion"`
	TipoInicio     string `gorm:"column:tipoInicio"`
	IDPais         int    `gorm:"column:idPais"`
	IDCiudad       int    `gorm:"column:idCiudad"`
	IDPunto        int    `gorm:"column:idPunto"`
	IDPerfil       int    `gorm:"column:idperfil"`
	Lat            string `gorm:"column:lat"`
	Login          string `gorm:"column:login"`
	IDUsuario      int    `gorm:"column:idUsuario"`
}
