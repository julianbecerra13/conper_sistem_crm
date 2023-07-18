class Domiciliarios{
  late int idDomiciliario;
  late String nombre;

  Domiciliarios({
    required this.idDomiciliario,
    required this.nombre,
  });

  factory Domiciliarios.fromJson(Map<String, dynamic> json) {
    return Domiciliarios(
      idDomiciliario: json['IdDomiciliario'] as int,
      nombre: json['Nombre'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'idDomiciliario': idDomiciliario,
      'nombre': nombre,
    };
  }
}