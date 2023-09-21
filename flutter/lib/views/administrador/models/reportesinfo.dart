class Reporte {
  late int id;
  late String nombre;
  late String descripcion;
  late String call;
  late String parametros;

  Reporte({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.call,
    required this.parametros,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['IdReporte'] as int,
      nombre: json['Nombre'] as String,
      descripcion: json['Descripcion'] as String,
      call: json['Call'] as String,
      parametros: json['Parametros'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Nombre': nombre,
      'Descripcion': descripcion,
      'Call': call,
      'Parametros': parametros,
    };
  }

}