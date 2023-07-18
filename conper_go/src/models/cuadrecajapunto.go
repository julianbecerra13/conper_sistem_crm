package models

type CuadreCajaPunto struct {
	IDPunto      string `gorm:"column:idPunto"`
	NombrePunto  string `gorm:"column:nombrePunto"`
	TotalOrdenes int    `gorm:"column:TotalOrdenes"`
	TotalVenta   int    `gorm:"column:TotalVenta"`
}
