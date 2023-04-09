import 'package:flutter/material.dart';
import 'db.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> submitLogin() async {
    final username = usernameController.text;
    final password = passwordController.text;

    // Verificar las credenciales utilizando DatabaseController
    final result = await DatabaseController.instance.verificarCredenciales(
      username,
      password,
    );

    // Cerrar la conexión a la base de datos
    await DatabaseController.instance.closeConnection();

    return result;
  }
}