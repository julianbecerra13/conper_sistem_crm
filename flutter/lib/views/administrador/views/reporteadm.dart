import 'dart:convert';
import 'package:conper/views/administrador/models/reportesinfo.dart';
import 'package:conper/views/administrador/views/components/menu.dart';
import 'package:conper/views/administrador/views/components/reportemodal.dart';
import 'package:conper/views/administrador/views/components/tablareportes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'package:http/http.dart' as http;

class Reportes extends StatefulWidget {
  const Reportes({Key? key}) : super(key: key);
  @override
  State<Reportes> createState() => _ReportesState();
}

class _ReportesState extends State<Reportes> {
  List<Map<String, dynamic>> reportesList = [];

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
        reportesList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getPqrs() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/reporteinfo'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["reportes"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Reporte.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }

    List<Map<String, dynamic>> orderMap = [];

    for (var order in orders) {
      orderMap.add(order.toJson());
    }
    return orderMap;
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
                        "REPORTES",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
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
                                ),
                              )),
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child: Card(
                                  elevation: 8,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(20),
                                    child: Tablaroportes(
                                      data: reportesList,
                                      headers: const [
                                        {"key": "Id", "Titulo": "ID"},
                                        {"key": "Nombre", "Titulo": "Reporte"},
                                        {
                                          "key": "Descripcion",
                                          "Titulo": "Descripcion"
                                        },
                                      ],
                                      onButtonPressed: (info) async {
                                        var idreporte = info['Id'];
                                        var call = info['Call'];
                                        final apiUrl = Uri.parse(
                                            'http://localhost:8080/parametrosreportes');

                                        // Crear el mapa del cuerpo de la solicitud
                                        final requestBody = {
                                          'id':
                                              idreporte // Convierte Idreporte a String
                                        };

                                        try {
                                          final response = await http.post(
                                            apiUrl,
                                            headers: {
                                              'Content-Type':
                                                  'application/json',
                                            },
                                            body: json.encode(requestBody),
                                          );

                                          if (response.statusCode == 200) {
                                            final jsonResponse =
                                                json.decode(response.body);
                                            // Llama a _showModal solo con Idreporte
                                            _showModal(
                                                context, jsonResponse, call);
                                          } else {
                                            print(
                                                'Error en la solicitud: ${response.statusCode}');
                                          }
                                        } catch (e) {
                                          print('Error en la solicitud: $e');
                                        }
                                      },
                                      showOptionalButton: false,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
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
      ),
    );
  }

  void _showModal(
      BuildContext context, Map<String, dynamic> jsonResponse, call) {
    var Call = call;
    Map<String, dynamic> formData = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Parsea las listas como List<Map<String, dynamic>>
        final parametros = (jsonResponse['parametros'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>();
        final datoscombo =
            (jsonResponse['parametrosComboData'] as Map<String, dynamic>?) ??
                {};

        return AlertDialog(
          title: const Text("Formulario Dinámico"),
          content: SingleChildScrollView(
            child: Column(
              children: parametros?.map<Widget>((parametro) {
                    final parametroNombre = parametro?['Parametro'];
                    final parametroQueryParametro =
                        parametro?['QueryParametro'];

                    if (parametroQueryParametro == "") {
                      if (parametroNombre == "Combo") {
                        if (datoscombo.containsKey(parametroNombre)) {
                          final datosCombo =
                              datoscombo[parametroNombre] as List<dynamic>;

                          if (datosCombo.isNotEmpty) {
                            return DropdownButtonFormField<String>(
                              value: formData[parametroNombre] ??
                                  datosCombo[0]['Nombre'],
                              onChanged: (value) {
                                final selectedCombo = datosCombo.firstWhere(
                                    (combo) => combo['Nombre'] == value);
                                setState(() {
                                  formData[parametroNombre] =
                                      selectedCombo['Codigo'];
                                });
                              },
                              items: datosCombo
                                  .map<DropdownMenuItem<String>>((combo) {
                                return DropdownMenuItem<String>(
                                  value: combo['Nombre'],
                                  child: Text(combo['Nombre']),
                                );
                              }).toList(),
                              decoration:
                                  InputDecoration(labelText: parametroNombre),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }
                      } else if (parametroNombre == "Numero") {
                        return TextField(
                          onChanged: (value) {
                            setState(() {
                              formData[parametroNombre] = int.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(labelText: parametroNombre),
                        );
                      } else {
                        return TextField(
                          onChanged: (value) {
                            setState(() {
                              formData[parametroNombre] = value;
                            });
                          },
                          decoration:
                              InputDecoration(labelText: parametroNombre),
                        );
                      }
                    }
                    return const SizedBox();
                  })?.toList() ??
                  [], // Usa una lista vacía si parametros es nulo
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Crear un mapa con los datos a enviar
                final dataToSend = {
                  "fromData":
                      formData, // Debe ser un objeto JSON con los campos y valores deseados
                  "Call": Call,
                };

                final apiUrl = Uri.parse('http://localhost:8080/procesar');

                try {
                  final response = await http.post(
                    apiUrl,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: json.encode(dataToSend),
                  );

                  if (response.statusCode == 200) {
                    try {
                      final jsonResponse = json.decode(response.body);
                      // Comprueba si la respuesta es una cadena y la convierte en un mapa
                      if (jsonResponse is String) {
                        _showModal1(context, json.decode(jsonResponse));
                      } else {
                        _showModal1(context, jsonResponse);
                      }
                    } catch (e) {
                      print('Error al decodificar la respuesta JSON: $e');
                    }
                  } else {
                    print('Error en la solicitud: ${response.statusCode}');
                  }
                } catch (e) {
                  print('Error en la solicitud: $e');
                }
              },
              child: const Text("Enviar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _showModal1(BuildContext context, Map<String, dynamic> jsonResponse) {
    final jsonString = json.encode(jsonResponse);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportesModal(jsonResponse: jsonString);
      },
    );
  }
}
