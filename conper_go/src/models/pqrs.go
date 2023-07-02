package models

type Pqrs struct {
	IDcaso int `gorm:"column:idPqrGestion"`
	FechaCaso string `gorm:"column:FechaCaso"`
	ResponsableEncargado string `gorm:"column:ResponsableEncargado"`
	Tipo string `gorm:"column:Tipo"`
	RequerimientoCliente string `gorm:"column:RequerimientoCliente"`
	GestionaRealizar string `gorm:"column:Gestion_a_Realizar"`
	RespuestaResponsable string `gorm:"column:RespuestaResponsable"`
}
