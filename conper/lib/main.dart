// ignore: unused_import
import 'package:conper/views/domicilios.dart';
import 'package:conper/views/pedidos.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
// ignore: unused_import
import '/views/trasabilidad.dart';
// ignore: unused_import
import '/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conper',
      debugShowCheckedModeBanner: false,
      home: VRouter(
        routes: [
          // Aquí definimos nuestras rutas
          VWidget(
            path: '/',
            widget: const Pedidos(),
            stackedRoutes: [
              VWidget(path: '/trasabilidad', widget: const Trasabilidad()),
              VWidget(path: '/pedidos', widget: const Pedidos()),
              VWidget(path: '/domicilios', widget: const Domicilios()),
             
            ],
          ),
        ],
      ),
    );
  }
}
