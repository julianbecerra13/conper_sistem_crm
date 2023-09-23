// Librerías
import 'dart:convert';

import 'package:conper/models/pqrs.dart';
import 'package:conper/views/administrador/views/components/menu.dart';
import 'package:conper/views/components/tabla.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'package:http/http.dart' as http;

class Pqrsadm extends StatefulWidget {
  final int idpunto;
  const Pqrsadm(this.idpunto, {Key? key}) : super(key: key);
  @override
  State<Pqrsadm> createState() => _pqrsState();
}

class _pqrsState extends State<Pqrsadm> {
  List<Map<String, dynamic>> pqrsList = [];

  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    VRouter.of(context).to('/');
  }

  @override
  void initState() {
    super.initState();
    getPqrs();
  }

  void getPqrs() async {
    await _getPqrs().then((value) {
      setState(() {
        pqrsList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getPqrs() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/pqrs?idNivel=1&idPunto=${widget.idpunto}'));
    List<dynamic> pq = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["Pqrs"];
      if (data == null) {
        return [];
      }
      pq = data.map((i) => Pqr.fromJson(i)).toList();
    } else {
      throw Exception('Failed to Pqrs');
    }

    List<Map<String, dynamic>> pqrsMap = [];

    for (var i in pq) {
      pqrsMap.add(i.toJson());
    }
    return pqrsMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        const MenuAdmin(),
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
                      "PQRS",
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
                                "PQRS ACTIVOS",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height - 300,
                              child: Card(
                                elevation: 8,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(20),
                                  child: Tabla(
                                      data: pqrsList,
                                      headers: const [
                                        {
                                          "Titulo": "Numero Caso",
                                          "key": 'IDcaso'
                                        },
                                        {
                                          "Titulo": "Fecha del Caso",
                                          "key": 'FechaCaso'
                                        },
                                        {
                                          "Titulo": "Responsable Encargado",
                                          "key": 'ResponsableEncargado'
                                        },
                                        {"Titulo": "Tipo", "key": 'Tipo'},
                                        {
                                          "Titulo": "Requerimiento Cliente",
                                          "key": 'RequerimientoCliente'
                                        },
                                        {
                                          "Titulo": "Gestion a Realizar",
                                          "key": 'GestionaRealizar'
                                        },
                                        {
                                          "Titulo": "Respuesta del Responsable",
                                          "key": 'RespuestaResponsable'
                                        }
                                      ],
                                      onButtonPressed: (info) async {
                                        _showModalRespuesta(context, info);
                                      },
                                      child: const Text("Responder")),
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

  final TextEditingController respuestaController = TextEditingController();
  void _showModalRespuesta(BuildContext context, info) {
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
                  "RESPONDER PQRS",
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
                      controller: respuestaController,
                      onSubmitted: (value) async {
                        final prefs = await SharedPreferences.getInstance();
                        await http
                            .put(
                                Uri.parse(
                                    'http://localhost:8080/respuestaPqrs'),
                                body: json.encode({
                                  "IdPqrs": info["IDcaso"],
                                  "respuesta": respuestaController.text,
                                  "IdCliente": prefs.getString("login"),
                                }))
                            .then((value) {
                          if (value.statusCode == 200) {
                            Navigator.pop(context);
                            getPqrs();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Se ha Respodió el PQRS Correctamente'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No se ha posdido responder el PQRS'),
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
                      respuestaController.clear();
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
