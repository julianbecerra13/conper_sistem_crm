// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:conper/models/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vrouter/vrouter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controladores de texto para el usuario y contraseña
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Función para enviar la solicitud HTTP de inicio de sesión

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      // URL de la API de inicio de sesión
      final url = Uri.parse('http://0.0.0.0:8080/login');

      // Crear el cuerpo de la solicitud con los datos del usuario y contraseña
      final body = jsonEncode({
        'username': _userController.text,
        'password': _passwordController.text,
      });

      // Realizar la solicitud HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Verificar la respuesta del servi1010197022dor
      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, mostrar un diálogo de éxito
        // guardamos los datos de inicio de sesión en el almacenamiento local
        final prefs = await SharedPreferences.getInstance();
        
        final login = Login.fromJson(json.decode(response.body));
        await prefs.setString('nombre', login.nombre);
        await prefs.setInt('IDPunto', login.idPunto);
        await prefs.setString('login', login.login);

        VRouter.of(context).to('/trasabilidad');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '¡Inicio de sesión exitoso! Bienvenido, ${prefs.getString('nombre')}'),
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Aceptar',
              onPressed: () {},
            ),
          ),
        );
      } else {
        // Si la respuesta no es exitosa, mostrar un diálogo de error
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('username') ?? '';
        final password = prefs.getString('password') ?? '';
        _userController.text = username;
        _passwordController.text = password;

        VRouter.of(context).to('/');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'No se pudo iniciar sesión. Verifique sus credenciales.'),
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Aceptar',
              onPressed: () {},
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height < 700
            ? 700
            : MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Color.fromRGBO(255, 255, 255, 9),
          ],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Image.asset(
                    'images/logo.png',
                    width: MediaQuery.of(context).size.width < 1080 ? 250 : 350,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 325,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        const Text(
                          'Binevenido a Conper',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Please Login to Your Account',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _userController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              suffixIcon: Icon(
                                FontAwesomeIcons.user,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              suffixIcon: Icon(
                                FontAwesomeIcons.lock,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              // AQUI DEBE LLAMAR LA FUNCION VERIFICAR USUARIO
                              login();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
