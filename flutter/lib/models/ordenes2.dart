
class Ordenes2{

  late int idOrdenGeneral;
  late String nombreCliente;
  late String direccionOrden;
  late double totalOrden;
  late String fechaCrea;
  late String nombreTraza;
  late String nombreDomiciliario;
  late String nombrePunto;
  late String observaciones;
  late String telefono;

  Ordenes2({
    required this.idOrdenGeneral,
    required this.nombreCliente,
    required this.direccionOrden,
    required this.totalOrden,
    required this.fechaCrea,
    required this.nombreTraza,
    required this.nombreDomiciliario,
    required this.nombrePunto,
    required this.observaciones,
    required this.telefono,

  });

  factory Ordenes2.fromJson(Map<String, dynamic> json) {
    return Ordenes2(

      idOrdenGeneral: json['IDOrdenGeneral'] as int,
      nombreCliente: json['NombreCliente'] as String,
      direccionOrden: json['DireccionOrden'] as String,
      totalOrden: json['TotalOrden'] as double,
      fechaCrea: json['FechaCrea'] as String,
      nombreTraza: json['NombreTraza'] as String,
      nombreDomiciliario: json['NombreDomiciliario'] as String,
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
      'NombreDomiciliario': nombreDomiciliario,
      'PuntodeVenta': nombrePunto,
      'Observaciones': observaciones,
      'Telefono': telefono,


    };
  }

}