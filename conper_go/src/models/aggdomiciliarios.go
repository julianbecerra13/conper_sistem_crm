package models

type AggDomiciliarios struct {
	Nombre         string `gorm:"column:nombre"`
	Identificacion string `gorm:"column:identificacion"`
	Telefono       string `gorm:"column:celular"`
	IdPunto        int    `gorm:"column:idPunto"`
}
