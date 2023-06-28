import 'package:conper/views/cajadomi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/domiciliario.dart';
import '../cajapunto.dart';

class Menu extends StatefulWidget {
  Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
                      _showModalCuadre(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    child: const Text("Cuadre de Caja"))),
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
                      VRouter.of(context).to('/novedades');
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
                    child: const Text("Generar Archivo Post"))),
            Container(
                width: 10,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 243, 117),
                  border: Border.all(
                      color: const Color.fromARGB(255, 33, 243, 117), width: 1),
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
                    child: const Text("PQRS"))),
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
                                                    'http://localhost:8080/archivopost'),
                                                body: json.encode({
                                                  "FechaInicio":
                                                      fechaController.text,
                                                  "IDPunto":
                                                      prefs.getInt('IDPunto'),
                                                }))
                                            .then((response) {
                                          if (response.statusCode == 200) {
                                            Navigator.pop(context);
                                            _showModalresponse(
                                                context, response);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Algo anda mal...')));
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
          }),
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
                "Recuerda revisar la ruta donde se almacena los archivos POST"),
          ],
        ));
      },
    );
  }

  void _showModalCuadre(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  _showModalPunto(context);
                },
                child: const Text("Caja Punto")),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () {
                  _showModalDomiciliario(context);
                },
                child: const Text("Caja Domicilio")),
          ],
        ));
      },
    );
  }

  List<Map<String, dynamic>> domiciliariosList = [];
  @override
  void initState() {
    super.initState();
    getDomiciliarios();
  }

  void getDomiciliarios() async {
    await _getDomiciliarios().then((value) {
      setState(() {
        domiciliariosList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getDomiciliarios() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://localhost:8080/domiciliarios?idCliente=${prefs.getString("login")}&idTraza=${prefs.getInt("IDPunto")}'));
    List<dynamic> domici = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["domiciliarios"];
      if (data == null) {
        return [];
      }
      domici = data
          .map((domiciliario) => Domiciliarios.fromJson(domiciliario))
          .toList();
    } else {
      throw Exception('Failed to load domiciliarios');
    }

    List<Map<String, dynamic>> domiciliariosMap = [];

    for (var domiciliario in domici) {
      domiciliariosMap.add(domiciliario.toJson());
    }
    return domiciliariosMap;
  }

  void _showModalDomiciliario(BuildContext context) {
    TextEditingController inicioController = TextEditingController();
    TextEditingController finController = TextEditingController();

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
                    const Text(
                      "Caja Domicilio",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ignore: sized_box_for_whitespace
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 1000,
                              child: TextField(
                                controller: inicioController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Fecha Inicio aaaa-mm-dd',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 1000,
                              child: TextField(
                                controller: finController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Fecha Fin aaaa-mm-dd',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              String inicio = inicioController.text;
                              String fin = finController.text;

                              _showModall(context, inicio, fin);
                            },
                            child: const Text('Capture'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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

  void _showModall2(BuildContext context, inicio, fin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Cajapunto(
            inicio: inicio,
            fin: fin,
          ),
        );
      },
    );
  }

  void _showModalPunto(BuildContext context) {
    TextEditingController inicioController = TextEditingController();
    TextEditingController finController = TextEditingController();

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
                    const Text(
                      "Caja Punto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ignore: sized_box_for_whitespace
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 1000,
                              child: TextField(
                                controller: inicioController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Fecha Inicio aaaa-mm-dd',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 1000,
                              child: TextField(
                                controller: finController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Fecha Fin aaaa-mm-dd',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              String inicio = inicioController.text;
                              String fin = finController.text;
                              _showModall2(context, inicio, fin);
                            },
                            child: const Text('Capture'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
