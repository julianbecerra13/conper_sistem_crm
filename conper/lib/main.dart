import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'views/domicilios.dart';
import 'views/login.dart';
import 'views/novedades.dart';
import 'views/p_estancados.dart';
import 'views/pedidos.dart';
import 'views/pqrs.dart';
import 'views/trasabilidad.dart';

void main() {
  runApp(const MyApp());
}

Future<bool> hasToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? token = prefs.getInt('IDPunto');
  return token != null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        VWidget(path: '/pqrs', widget: const Pqrs()),
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
