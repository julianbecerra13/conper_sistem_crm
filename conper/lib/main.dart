import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import '/views/trasabilidad.dart';
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
            widget: const Trasabilidad(),
            stackedRoutes: [
              VWidget(path: '/trasabilidad', widget: const Trasabilidad()),
             
            ],
          ),
        ],
      ),
    );
  }
}
