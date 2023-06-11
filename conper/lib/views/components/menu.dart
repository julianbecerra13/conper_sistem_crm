import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Drawer(
        elevation: 20,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(158, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text('Pedidos Estancados',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.dangerous, color: Colors.red),
                onTap: () {
                  VRouter.of(context).to('/p_estancados');
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(158, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text('Trasabilidad',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                leading:
                    const Icon(Icons.arrow_circle_right, color: Colors.blue),
                onTap: () {
                  VRouter.of(context).to('/trasabilidad');
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(158, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Pedidos'),
                      leading: const Icon(Icons.food_bank),
                      onTap: () {
                        VRouter.of(context).to('/pedidos');
                      },
                    ),
                    // divider
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      title: const Text('Domicilios'),
                      leading: const Icon(Icons.delivery_dining),
                      onTap: () {
                        VRouter.of(context).to('/domicilios');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                width: 10,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      // ignore: avoid_print
                      print(prefs.getInt('IDPunto'));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    child: const Text("Novedades"))),
            const SizedBox(height: 5),
            Container(
                width: 10,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await http
                          .put(Uri.parse('http://localhost:8080/impresora'),
                              body: json
                                  .encode({'idPunto': prefs.getInt('IDPunto')}))
                          .then((response) {
                        if (response.statusCode == 200) {
                          _showModalImpresora(context);
                        } else {
                          debugPrint("Error al enviar la prueba de impresora");
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    child: const Text("Prueba de Impresora"))),
          ],
        ),
      ),
    );
  }

  void _showModalImpresora(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(content: Text("Prueba de Impresora Enviada"));
      },
    );
  }
}
