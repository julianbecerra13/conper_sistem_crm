class DomiPriv {
  late int id;
  late String idOrdenNumero;
  late String nombre;
  late String telefono;
  late String direccion;
  late String totalorden;
  late String fechacrea;

  DomiPriv({
    required this.id,
    required this.idOrdenNumero,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.totalorden,
    required this.fechacrea,
  });

  factory DomiPriv.fromJson(Map<String, dynamic> json) {
    return DomiPriv(
      id: json['IdPedido'] as int,
      idOrdenNumero: json['IdOrdenNumero'] as String,
      nombre: json['NombreCliente'] as String,
      telefono: json['TelefonoCelular'] as String,
      direccion: json['Direccion'] as String,
      totalorden: json['TotalOrden'] as String,
      fechacrea: json['FechaCrea'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'idGeneral': id,
      'idOrdenNumero': idOrdenNumero,
      'Nombre': nombre,
      'Telefono': telefono,
      'Direccion': direccion,
      'TotalOrden': totalorden,
      'FechaCrea': fechacrea,
    };
  }

}