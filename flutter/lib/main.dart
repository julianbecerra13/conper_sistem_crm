import 'package:conper/views/domiciliopriv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
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
      initialUrl: '/domiciliario', // Cambiado a /domiciliario
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
        } else {
          final prefs = await SharedPreferences.getInstance();
          final login = prefs.getString('login');
          if (login != "6") {
            vRedirector.to(
                '/domicilios'); // Redirige a la vista que quieras para usuarios no permitidos
          }
        }
      },
      stackedRoutes: [
        VWidget(path: '/domiciliario', widget: const DomiciliosPriv()),
      ],
    ),
    VGuard(
      beforeEnter: (vRedirector) async {
        bool tokenExists = await hasToken();
        if (tokenExists) {
          vRedirector.to('/domiciliario'); // Cambiado a /domiciliario
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
