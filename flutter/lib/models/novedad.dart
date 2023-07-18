class Nove{

  late int concecutivoNovedad;
  late String marca;
  late String nombrePuntoVenta;
  late String novedad;
  late String descripcion;
  late String fechaCrea;

  Nove({
    required this.concecutivoNovedad,
    required this.marca,
    required this.nombrePuntoVenta,
    required this.novedad,
    required this.descripcion,
    required this.fechaCrea,
  });

  factory Nove.fromJson(Map<String, dynamic> json) {
    return Nove(
      concecutivoNovedad: json['ConcecutivoNovedad'] as int,
      marca: json['Marca'] as String,
      nombrePuntoVenta: json['NombrePuntoVenta'] as String,
      novedad: json['Novedad'] as String,
      descripcion: json['Descripcion'] as String,
      fechaCrea: json['FechaCrea'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'ConcecutivoNovedad': concecutivoNovedad,
      'Marca': marca,
      'NombrePuntoVenta': nombrePuntoVenta,
      'Novedad': novedad,
      'Descripcion': descripcion,
      'FechaCrea': fechaCrea,
    };
  }
}