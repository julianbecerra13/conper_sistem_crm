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
      nombre: json['Nombre'] as String,
      idPunto: json['IDPunto'] as int,
      login: json['Login'] as String,
    );
  }
}
