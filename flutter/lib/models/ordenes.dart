class Ordenes {
  late int idOrdenGeneral;
  late String idOrdenNumero;
  late String nombreCliente;
  late String direccionOrden;
  late double totalOrden;
  late String fechaCrea;
  late String nombreTraza;
  late int idPunto;
  late String nombrePunto;
  late String observaciones;
  late String telefono;

  Ordenes({
    required this.idOrdenGeneral,
    required this.idOrdenNumero,
    required this.nombreCliente,
    required this.direccionOrden,
    required this.totalOrden,
    required this.fechaCrea,
    required this.nombreTraza,
    required this.idPunto,
    required this.nombrePunto,
    required this.observaciones,
    required this.telefono,
  });

  factory Ordenes.fromJson(Map<String, dynamic> json) {
    return Ordenes(
      idOrdenGeneral: json['IDOrdenGeneral'] as int,
      idOrdenNumero: json['IdOrdenNumero'] as String,
      nombreCliente: json['NombreCliente'] as String,
      direccionOrden: json['DireccionOrden'] as String,
      totalOrden: json['TotalOrden'] as double,
      fechaCrea: json['FechaCrea'] as String,
      nombreTraza: json['NombreTraza'] as String,
      idPunto: json['IdPunto'] as int,
      nombrePunto: json['PuntodeVenta'] as String,
      observaciones: json['Observaciones'] as String,
      telefono: json['Telefono'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'idGeneral': idOrdenGeneral,
      'NombreCliente': nombreCliente,
      'DireccionOrden': direccionOrden,
      'TotalOrden': totalOrden,
      'FechaCrea': fechaCrea,
      'NombreTraza': nombreTraza,
      'IdPunto': idPunto,
      'PuntodeVenta': nombrePunto,
      'Observaciones': observaciones,
      'Telefono': telefono,
      'idOrdenNumero': idOrdenNumero,
    };
  }
}
