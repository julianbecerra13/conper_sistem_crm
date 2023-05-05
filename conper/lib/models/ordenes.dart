
import 'dart:typed_data';

class Ordenes{

  late int idOrdenGeneral;
  late String nombreCliente;
  late String direccionOrden;
  late double totalOrden;
  late String fechaCrea;
  late String nombreTraza;

  Ordenes({
    required this.idOrdenGeneral,
    required this.nombreCliente,
    required this.direccionOrden,
    required this.totalOrden,
    required this.fechaCrea,
    required this.nombreTraza,
  });

  factory Ordenes.fromJson(Map<String, dynamic> json) {
    return Ordenes(
      idOrdenGeneral: json['IDOrdenGeneral'] as int,
      nombreCliente: json['NombreCliente'] as String,
      direccionOrden: json['DireccionOrden'] as String,
      totalOrden: json['TotalOrden'] as double,
      fechaCrea: json['FechaCrea'] as String,
      nombreTraza: json['NombreTraza'] as String,
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
    };
  }



}