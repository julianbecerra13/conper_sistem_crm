import 'package:conper/views/cajadomi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuAdmin extends StatefulWidget {
  MenuAdmin({Key? key}) : super(key: key);

  @override
  State<MenuAdmin> createState() => _MenuState();
}

class _MenuState extends State<MenuAdmin> {
  String nombrePunto = ''; // Variable para almacenar el nombre del punto

  @override
  void initState() {
    super.initState();
    getNombrePunto(); // O
  }

  void getNombrePunto() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString('nombre');
    setState(() {
      nombrePunto =
          nombre ?? ''; // Asigna el nombre del punto a la variable nombrePunto
    });
  }

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
              height: 20,
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 129, 187, 244),
              ),
              child: Text(
                nombrePunto, // Usa la variable nombrePunto aquí
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                  VRouter.of(context).to('/estancadosadmin');
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
                  _showModalCuadre(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Cuadre de Cajas"),
              ),
            ),
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
                  _showModalArchivoPost(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Archivo Post"),
              ),
            ),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 243, 117),
                border: Border.all(
                  color: const Color.fromARGB(255, 33, 243, 117),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  VRouter.of(context).to('/pqrs');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("PQRS"),
              ),
            ),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 243, 117),
                border: Border.all(
                  color: const Color.fromARGB(255, 33, 243, 117),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  VRouter.of(context).to('/pqrs');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Reportes"),
              ),
            )
          ],
        ),
      ),
    );
  }

  final TextEditingController fechaController = TextEditingController();

  void _showModalArchivoPost(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Archivo Post",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      elevation: 8,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: fechaController,
                                        decoration: const InputDecoration(
                                          labelText: 'Fecha Formato aaaa-mm-dd',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese la Fecha';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await http
                                              .put(
                                            Uri.parse(
                                              'http://localhost:8080/archivopost',
                                            ),
                                            body: json.encode({
                                              "FechaInicio":
                                                  fechaController.text,
                                              "IDPunto":
                                                  prefs.getInt('IDPunto'),
                                            }),
                                          )
                                              .then((response) {
                                            if (response.statusCode == 200) {
                                              Navigator.pop(context);
                                              _showModalresponse(
                                                  context, response);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Algo anda mal...',
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.blue,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              'Generar Archivo POST',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showModalresponse(BuildContext context, response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text("${response.body}"),
              const SizedBox(height: 10),
              const Text(
                "Recuerda revisar la ruta donde se almacena los archivos POST",
              ),
            ],
          ),
        );
      },
    );
  }

  void _showModalCuadre(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("selecionare el punto para hacer el cuadre"),
            ],
          ),
        );
      },
    );
  }

  void _showModall(BuildContext context, inicio, fin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Cajacuadre(
            inicio: inicio,
            fin: fin,
          ),
        );
      },
    );
  }
}
