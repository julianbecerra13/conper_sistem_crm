import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import '/views/dashboard.dart';
import '/views/login.dart';
void main() {
  runApp( const MyApp());
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
            widget: const LoginPage(),
            stackedRoutes: [
              VWidget(path: '/dashboard', widget: const Dashboard()),
            ],
          ),
        ],
      ),
    );
  }
}
