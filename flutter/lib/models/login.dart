class Login {
  late String nombre;
  late int  idPunto;
  late String login;
  late int idUsuario;
 
  Login({
    required this.nombre,
    required this.idPunto,
    required this.login,
    required this.idUsuario,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      nombre: json['Nombre'] as String,
      idPunto: json['IDPunto'] as int,
      login: json['IDPerfil'].toString(),
      idUsuario: json['IDUsuario'] as int,
    );
  }
}