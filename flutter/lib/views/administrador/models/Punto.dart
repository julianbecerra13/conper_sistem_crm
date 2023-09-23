class Punto {
  late int id;
  late String nombre;

  Punto({
    required this.id,
    required this.nombre,
  });

  factory Punto.fromJson(Map<String, dynamic> json) {
    return Punto(
      id: json['IdPunto'] as int,
      nombre: json['Nombre'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Nombre': nombre,
    };
  }
}