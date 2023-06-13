// Librerías
import 'dart:convert';

import 'package:conper/models/novedad.dart';
import 'package:conper/views/components/menu.dart';
import 'package:conper/views/components/tabla.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'package:http/http.dart' as http;

class Novedades extends StatefulWidget {
  const Novedades({Key? key}) : super(key: key);
  @override
  State<Novedades> createState() => _NovedadesState();
}

class _NovedadesState extends State<Novedades> {
  List<Map<String, dynamic>> novedadesList = [];

  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    VRouter.of(context).to('/');
  }

  @override
  void initState() {
    super.initState();
    getNovedades();
  }

  void getNovedades() async {
    await _getNovedades().then((value) {
      setState(() {
        novedadesList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getNovedades() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://localhost:8080/novedades?idUsuario=${prefs.getString("login")}&idPunto=${prefs.getInt("IDPunto")}'));
    List<dynamic> nove = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["novedades"];
      if (data == null) {
        return [];
      }
      nove = data.map((i) => Nove.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load Novedades');
    }

    List<Map<String, dynamic>> novedadesMap = [];

    for (var i in nove) {
      novedadesMap.add(i.toJson());
    }
    return novedadesMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        const Menu(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const Text(
                      "NOVEDADES",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 450,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 40,
                              child: const TextField(
                                controller: null,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Buscar...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                            onPressed: () => _logOut(context),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 12.0),
                              child: Text('Cerrar sesión',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "NOVEDADES ACTIVAS",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "AGREGAR UNA NOVEDAD :",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    int valor = 1;
                                    _showModalnove(context, valor);
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("PROMOCIONAR")),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    int valor = 2;
                                    _showModalnove(context, valor);
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("AGOTADO EN EL DIA")),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    int valor = 3;
                                    _showModalnove(context, valor);
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("INICIO SIN STOCK")),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    int valor = 4;
                                    _showModalnove(context, valor);
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("OTROS")),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height - 300,
                              child: Card(
                                elevation: 8,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(20),
                                  child: Tabla(
                                      data: novedadesList,
                                      headers: const [
                                        {
                                          "Titulo": "concecutivo",
                                          "key": 'ConcecutivoNovedad'
                                        },
                                        {"Titulo": "marca", "key": 'Marca'},
                                        {
                                          "Titulo": "nombre punto venta",
                                          "key": 'NombrePuntoVenta'
                                        },
                                        {"Titulo": "novedad", "key": 'Novedad'},
                                        {
                                          "Titulo": "fecha creación",
                                          "key": 'FechaCrea'
                                        }
                                      ],
                                      onButtonPressed: (informacion) async {
                                        await http
                                            .put(
                                                Uri.parse(
                                                    'http://localhost:8080/aggnovedad1'),
                                                body: json.encode({
                                                  "level": 2,
                                                  "IdPunto": 0,
                                                  "IdNovedad": 0,
                                                  "Novedad": "",
                                                  "IdCliente": 1,
                                                  "Idcp": informacion["ConcecutivoNovedad"],
                                                  "Activo": 0
                                                }))
                                            .then((value) {
                                          if (value.statusCode == 200) {
                                            getNovedades();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Se ha Desactivado Correctamente la Novedad'),
                                              ),
                                              
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'No se ha podido Desactivar la Novedad'),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: const Text("Desactivar")),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  final TextEditingController novedadController = TextEditingController();
  void _showModalnove(BuildContext context, int valor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Card(
          elevation: 8,
          child: Center(
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Novedad",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "PRECIONA ENTER PARA ENVIAR",
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                      controller: novedadController,
                      onSubmitted: (value) async {
                        final prefs = await SharedPreferences.getInstance();
                        await http
                            .put(Uri.parse('http://localhost:8080/aggnovedad1'),
                                body: json.encode({
                                  "level": 1,
                                  "IdPunto": prefs.getInt("IDPunto"),
                                  "IdNovedad": valor,
                                  "Novedad": novedadController.text,
                                  "IdCliente": 1,
                                  "Idcp": 0,
                                  "Activo": 1
                                }))
                            .then((value) {
                          print(value.body);
                          if (value.statusCode == 200) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Se ha Agregado Correctamente la Novedad'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No se ha podido Agregar la Novedad'),
                              ),
                            );
                          }
                        });
                      }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      novedadController.clear();
                    },
                    child: const Text("Cancelar"))
              ],
            )),
          ),
        ));
      },
    );
  }
}
