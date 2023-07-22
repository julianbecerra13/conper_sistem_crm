class Domi {
  late String nombre;
  late String identificacion;
  late String telefono;
  late int idPunto;

  Domi({
    required this.nombre,
    required this.identificacion,
    required this.telefono,
    required this.idPunto,
  });

  factory Domi.fromJson(Map<String, dynamic> json) {
    return Domi(
      nombre: json['Nombre'] as String,
      identificacion: json['Identificacion'] as String,
      telefono: json['Telefono'] as String,
      idPunto: json['IdPunto'] as int,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'Nombre': nombre,
      'Identificacion': identificacion,
      'Telefono': telefono,
      'IdPunto': idPunto,
    };
  }
}
