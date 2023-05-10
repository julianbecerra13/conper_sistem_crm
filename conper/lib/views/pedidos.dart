import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';
import '../models/domiciliario.dart';
import 'components/modal.dart';
import 'components/tabla.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ordenes.dart';

// _logOut(context); // llamar a la función _logOut

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  late List<Map<String, dynamic>> ordersTraza = [];
  List<Map<String, dynamic>> domiciliariosList = [];

  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    getOrders();
    getDomiciliarios();
  }

  void getOrders() async {
    await _getOrders().then((value) {
      setState(() {
        ordersTraza = value;
      });
    });
  }

  void getDomiciliarios() async {
    await _getDomiciliarios().then((value) {
      setState(() {
        domiciliariosList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getOrders() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/pedidos?idCliente=1&idTraza=2&idPunto=60'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["ordenes"];
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

  Future<List<Map<String, dynamic>>> _getDomiciliarios() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/domiciliarios?idCliente=1&idTraza=60'));
    List<dynamic> domici = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["domiciliarios"];
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
                                    "PEDIDOS",
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
                                      MediaQuery.of(context).size.height - 300,
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
                                      {"Titulo": 'Fecha', "key": "FechaCrea"},
                                      {
                                        "Titulo": 'Estado',
                                        "key": "NombreTraza"
                                      },
                                    ],                             
                                    // ignore: non_constant_identifier_names
                                    onButtonPressed: (info) {
                                      print(info);
                                      _showModal(context, info);
                                    },
                                    child: const Icon(
                                      Icons.motorcycle,
                                      color: Colors.white,
                                      size: 30,
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
          content: MyModalContent(domiciliariosList: domiciliariosList, informacion: info),
        );
      },
    );
  }
}
