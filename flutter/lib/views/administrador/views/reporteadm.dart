import 'dart:convert';
import 'package:conper/views/administrador/models/reportesinfo.dart';
import 'package:conper/views/administrador/views/components/menu.dart';
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
          MenuAdmin(),
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
                                        final id = info["Id"];
                                        final infocall = info["Call"];

                                        if (id == 1) {
                                          // Abre un modal con un formulario de 3 inputs
                                          showModalWithForm(context, infocall);
                                        } else if (id == 2) {
                                          // Abre un modal con un formulario de 2 inputs
                                          showModalWithFormTwo(
                                              context, infocall);
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

  void showModalWithForm(BuildContext context, String infocall) async {
    final TextEditingController param1Controller = TextEditingController();
    final TextEditingController param2Controller = TextEditingController();
    final TextEditingController param4Controller = TextEditingController();
    final TextEditingController param5Controller = TextEditingController();
    String selectedComboKey = '';

    final Map<String, String> comboOptions = {
      'Seleccione una opción de combo': '',
      'Voz': '1',
      'Didi': '2',
      'Web': '3',
      'ClickDelivery-Delrodeo': '17',
      'Rappi-Delrodeo': '18',
      'PaginaWeb-Delrodeo': '19',
      'Pedidosya-Delrodeo': '20',
      'Uber Eats-Delrodeo': '21',
      'Ifood-Delrodeo': '23',
      'DidiFood': '24',
      'Descuento Rodeo': '87',
      'ND': '89',
    };

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Formulario de Respuesta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: param1Controller,
                decoration: InputDecoration(labelText: 'Fecha'),
              ),
              TextFormField(
                controller: param2Controller,
                decoration: InputDecoration(labelText: 'Hora'),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedComboKey,
                items: comboOptions.keys.map((String optionText) {
                  final optionKey = comboOptions[optionText]!;
                  return DropdownMenuItem<String>(
                    value: optionKey,
                    child: Text(optionText),
                  );
                }).toList(),
                onChanged: (String? newKey) {
                  setState(() {
                    selectedComboKey = newKey!;
                  });
                },
              ),
              TextFormField(
                controller: param4Controller,
                decoration: InputDecoration(labelText: 'Texto'),
              ),
              TextFormField(
                controller: param5Controller,
                decoration: InputDecoration(labelText: 'Numero'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final call = infocall;
                final param1 = param1Controller.text;
                final param2 = param2Controller.text;
                final param3 = selectedComboKey;
                final param4 = param4Controller.text;
                final param5 = param5Controller.text;

                final requestBody = {
                  "Cadena": call,
                  "Param1": param1,
                  "Param2": param2,
                  "Param3": param3,
                  "Param4": param4,
                  "Param5": param5,
                };

                final requestBodyJson = jsonEncode(requestBody);

                final response = await http.post(
                  Uri.parse('http://localhost:8080/procesar'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: requestBodyJson,
                );

                if (response.statusCode == 200) {
                  // La solicitud se completó con éxito
                  print('Respuesta de la API: ${response.body}');

                  // Procesar la respuesta de la API y mostrarla en un nuevo modal
                  final responseData = json.decode(response.body);
                  if (responseData != null &&
                      responseData['columns'] != null &&
                      responseData['data'] != null) {
                    final columns = responseData['columns'] as List<String>;
                    final data = responseData['data'] as List<List<dynamic>>;

                    // Abre un nuevo modal para mostrar los resultados
                    Navigator.pop(
                        context); // Cerrar el modal de formulario actual
                    showResultModal(context, columns, data);
                  } else {
                    // Manejar el caso en que la respuesta de la API no tenga el formato esperado
                  }
                } else {
                  // Hubo un error en la solicitud a la API
                  print(
                      'Error en la solicitud a la API. Código de estado: ${response.statusCode}');
                }

                Navigator.of(context).pop();
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  void showModalWithFormTwo(BuildContext context, String infocall) async {
    final TextEditingController param1Controller = TextEditingController();
    final TextEditingController param2Controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Formulario de Respuesta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: param1Controller,
                decoration: InputDecoration(labelText: 'Fecha Inicial'),
              ),
              TextFormField(
                controller: param2Controller,
                decoration: InputDecoration(labelText: 'Fecha Final'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final call = infocall;
                final param1 = param1Controller.text;
                final param2 = param2Controller.text;

                final requestBody = {
                  "Cadena": call,
                  "Param1": param1,
                  "Param2": param2,
                };

                final requestBodyJson = jsonEncode(requestBody);

                final response = await http.post(
                  Uri.parse('http://localhost:8080/procesar'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: requestBodyJson,
                );

                if (response.statusCode == 200) {
                  // La solicitud se completó con éxito
                  print('Respuesta de la API: ${response.body}');

                  // Procesar la respuesta de la API y mostrarla en un nuevo modal
                  final responseData = json.decode(response.body);
                  if (responseData != null &&
                      responseData['columns'] != null &&
                      responseData['data'] != null) {
                    final columns = responseData['columns'] as List<String>;
                    final data = responseData['data'] as List<List<dynamic>>;

                    // Abre un nuevo modal para mostrar los resultados
                    Navigator.pop(
                        context); // Cerrar el modal de formulario actual
                    showResultModal(context, columns, data);
                  } else {
                    // Manejar el caso en que la respuesta de la API no tenga el formato esperado
                  }
                } else {
                  // Hubo un error en la solicitud a la API
                  print(
                      'Error en la solicitud a la API. Código de estado: ${response.statusCode}');
                }

                Navigator.of(context).pop();
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el modal de resultados
  void showResultModal(
      BuildContext context, List<String> columns, List<List<dynamic>> data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                columns:
                    columns.map((col) => DataColumn(label: Text(col))).toList(),
                rows: data
                    .map((row) => DataRow(
                        cells: row
                            .map((cell) => DataCell(Text(cell.toString())))
                            .toList()))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
