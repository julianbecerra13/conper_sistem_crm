package models

type Detalles struct {
	ItemNombre string `gorm:"column:itemNombre"`
	ValorBaseUni string `gorm:"column:valorBaseUni"`
	ValorTotal int `gorm:"column:valorTotal"`

}