package models

type Domiciliarios struct {
	IdDomiciliario int    `gorm:"column:idUsuario"`
	Nombre         string `gorm:"column:nombre"`
}
