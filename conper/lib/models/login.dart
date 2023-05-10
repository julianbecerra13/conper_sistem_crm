class Login {
  late String nombre;
  late int  idPunto;
  late String login;

  Login({
    required this.nombre,
    required this.idPunto,
    required this.login,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      nombre: json['nombre'] as String,
      idPunto: json['idPunto'] as int,
      login: json['Login'] as String,
    );
  }

  // return values as a map
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'IDPunto': idPunto,
      'login': login,
    };
  }
}
