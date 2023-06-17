// ignore: unused_import
import 'package:conper/models/login.dart';
import 'package:conper/views/domicilios.dart';
import 'package:conper/views/login.dart';
import 'package:conper/views/novedades.dart';
import 'package:conper/views/p_estancados.dart';
import 'package:conper/views/pedidos.dart';
import 'package:conper/views/pqrs.dart';
import 'package:conper/views/trasabilidad.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

void main() {
  runApp(const MyApp());
}

Future<bool> hasToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? token = prefs.getInt('IDPunto');
  return token != null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VRouter(
      mode: VRouterMode.history,
      title: 'Conper',
      debugShowCheckedModeBanner: false,
      initialUrl: '/trazabilidad',
      routes: buildRoutes(),
    );
  }
}

List<VRouteElement> buildRoutes() {
  return [
    
    VGuard(
      beforeEnter: (vRedirector) async {
        bool tokenExists = await hasToken();
        if (!tokenExists) {
          vRedirector.to('/login');
        }
      },
      stackedRoutes: [
        VWidget(path: '/trasabilidad', widget: const Trasabilidad()),
        VWidget(path: '/pedidos', widget: const Pedidos()),
        VWidget(path: '/p_estancados', widget: const PedidosEstancados()),
        VWidget(path: '/domicilios', widget: const Domicilios()),
        VWidget(path: '/novedades', widget: const Novedades()),
        VWidget(path: '/pqrs', widget: const Pqrs())
      ],
    ),
    VGuard(
      beforeEnter: (vRedirector) async {
        bool tokenExists = await hasToken();
        if (tokenExists) {
          vRedirector.to('/trasabilidad');
        }
      },
      stackedRoutes: [
        VWidget(path: '/login', widget: const LoginPage()),
      ],
    ),
    VRouteRedirector(
          redirectTo: '/login',
          path: r'*',
        ),
  ];
}
