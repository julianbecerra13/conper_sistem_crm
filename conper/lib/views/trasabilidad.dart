import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';
import 'package:vrouter/vrouter.dart';
import '../models/ordenes.dart';
import 'components/tabla.dart';
import 'package:http/http.dart' as http;

// _logOut(context); // llamar a la función _logOut

class Trasabilidad extends StatefulWidget {
  const Trasabilidad({super.key});

  @override
  State<Trasabilidad> createState() => _TrasabilidadState();
}

class _TrasabilidadState extends State<Trasabilidad> {
  List<Map<String, dynamic>> ordersTraza = [];

  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    VRouter.of(context).to('/');
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  void getOrders() async {
    await _getOrders().then((value) {
      setState(() {
        ordersTraza = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        'http://localhost:8080/domicilios?idCliente=${prefs.getString("login")}&idTraza=6&idPunto=${prefs.getInt("IDPunto")}'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["ordenes"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Ordenes.fromJson(order)).toList();
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
                        "TRASABILIDAD",
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
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "GENERAL",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  child: Card(
                                    elevation: 8,
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(20),
                                      child: Tabla(
                                        data: ordersTraza,
                                        headers: const [
                                          {
                                            "Titulo": 'ID orden',
                                            "key": "idGeneral"
                                          },
                                          {
                                            "Titulo": 'Nombre',
                                            "key": "NombreCliente"
                                          },
                                          {
                                            "Titulo": 'Direccion',
                                            "key": "DireccionOrden"
                                          },
                                          {
                                            "Titulo": 'Total de la orden',
                                            "key": "TotalOrden"
                                          },
                                          {
                                            "Titulo": 'Fecha',
                                            "key": "FechaCrea"
                                          },
                                          {
                                            "Titulo": 'Estado',
                                            "key": "NombreTraza"
                                          },
                                          {
                                            "Titulo": 'Domiciliario',
                                            "key": "domiciliario"
                                          },
                                        ],
                                        // ignore: avoid_types_as_parameter_names
                                        onButtonPressed: (info) {
                                          _showModal(context, info);
                                        },
                                        child: const Text("Detalles"),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showModal(BuildContext context, Map<String, dynamic> info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detalles de la orden",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("ID orden: ${info['idGeneral']}"),
              Text("Nombre: ${info['NombreCliente']}"),
              Text("Direccion: ${info['DireccionOrden']}"),
              Text("Total de la orden: ${info['TotalOrden']}"),
              Text("Fecha: ${info['FechaCrea']}"),
              Text("Domiciliario: ${info['domiciliario']}"),
              Text("Estado: ${info['NombreTraza']}"),
            ],
          ),
        );
      },
    );
  }
}
