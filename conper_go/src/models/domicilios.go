package models

type Domicilios  struct {
	IDOrdenGeneral int    `gorm:"column:idOrdenGeneral"`
	NombreCliente  string `gorm:"column:nombreCliente"`
	DireccionOrden string `gorm:"column:direccionOrden"`
	TotalOrden     float64    `gorm:"column:totalOrden"`
	FechaCrea      string `gorm:"column:fechaCrea"`
	NombreTraza    string `gorm:"column:nombreTraza"`
	NombreDomiciliario string `gorm:"column:domiciliario"`
}
