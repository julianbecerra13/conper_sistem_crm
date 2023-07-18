package models

type CuadreCaja struct {
	NombreMovil    string `gorm:"column:NombreMovil"`
	NombrePunto    string `gorm:"column:nombrePunto"`
	NombreTipoPago string `gorm:"column:nombreTipoPago"`
	TotalOrdenes   int    `gorm:"column:TotalOrdenes"`
	TotalVenta     int    `gorm:"column:TotalVenta"`
}
