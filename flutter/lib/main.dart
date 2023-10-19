import 'package:conper/views/administrador/views/admin.dart';
import 'package:conper/views/administrador/views/dashboard.dart';
import 'package:conper/views/administrador/views/domiciliosadm.dart';
import 'package:conper/views/administrador/views/p_estancadosadm.dart';
import 'package:conper/views/administrador/views/pedidosadm.dart';
import 'package:conper/views/administrador/views/reporteadm.dart';
import 'package:conper/views/domiciliopriv.dart';
import 'package:conper/views/domicilios.dart';
import 'package:conper/views/novedades.dart';
import 'package:conper/views/p_estancados.dart';
import 'package:conper/views/pedidos.dart';
import 'package:conper/views/pqrs.dart';
import 'package:conper/views/trasabilidad.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'views/administrador/views/pqrsadm.dart';
import 'views/login.dart';

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
      initialUrl: '/login',
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
        VWidget(path: '/pedidos', widget: const Pedidos()),
        VWidget(path: '/p_estancados', widget: const PedidosEstancados()),
        VWidget(path: '/domicilios', widget: const Domicilios()),
        VWidget(path: '/novedades', widget: const Novedades()),
        VWidget(path: '/pqrs', widget: const Pqrs()),
        VWidget(path: '/administrador', widget: const Administrador()),
        VWidget(path: '/estancadosadmin', widget: const PedidosEstancadosadm()),
        VWidget(path: '/domiciliosadmin', widget: const Domiciliosadm()),
        VWidget(path: '/pedidosadmin', widget: const Pedidosadm()),
        VWidget(path: '/dashboard', widget: const Dashboard()),
        VWidget(path: '/reportes', widget: const Reportes()),

        VGuard(
          beforeEnter: (vRedirector) async {
            final prefs = await SharedPreferences.getInstance();
            final loginValue = prefs.getString('login');
            if (loginValue == "6") {
              vRedirector.to('/domiciliario');
            } else if (loginValue == "1") {
              vRedirector.to('/dashboard');
            }
          },
          stackedRoutes: [
            VWidget(path: '/trasabilidad', widget: const Trasabilidad()),
          ],
        ),
        VWidget(path: '/domiciliario', widget: const DomiciliosPriv()),
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
