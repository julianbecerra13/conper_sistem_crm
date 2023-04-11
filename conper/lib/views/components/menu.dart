import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            // ListTile(
            //   title: const Text('Home'),
            //   onTap: () {
            //     // Update the state of the app
            //     VRouter.of(context).to('/dashboard');
            //     // Then close the drawer
            //     // Navigator.pop(context);
            //   },
            // ),
            ListTile(
              tileColor: Colors.blue,
              title: const Text('Trasabilidad'),
              onTap: () {
                VRouter.of(context).to('/trasabilidad');
              },
            ),
            ListTile(
              title: const Text('Pedidos'),
              onTap: () {
                VRouter.of(context).to('/inventario');
              },
            ),
            ListTile(
              title: const Text('Domicilios'),
              onTap: () {
                VRouter.of(context).to('/reportes');
              },
            ),
          ],
        ),
      ),
    );
  }
}
