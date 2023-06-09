import 'package:conper/views/components/modald.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';
import 'package:vrouter/vrouter.dart';
import '../models/domiciliario.dart';
import '../models/ordenes.dart';
import 'components/modal.dart';
import 'components/tabla.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  List<Map<String, dynamic>> domiciliariosList = [];
  List<Map<String, dynamic>> updatedOrdersTraza = [];

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
    getDomiciliarios();
  }

  void getOrders() async {
    await _getOrders().then((value) {
      setState(() {
        updatedOrdersTraza = value;
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
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        'http://backend:8080/pedidos?idCliente=${prefs.getString("login")}&idTraza=2&idPunto=${prefs.getInt("IDPunto")}'));
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

  Future<List<Map<String, dynamic>>> _getDomiciliarios() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://backend:8080/domiciliarios?idCliente=${prefs.getString("login")}&idTraza=${prefs.getInt("IDPunto")}'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Menu(),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "PEDIDOS",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height - 300,
                              child: Card(
                                elevation: 8,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(20),
                                  child: Tabla(
                                    data: updatedOrdersTraza,
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
                                    onButtonPressed: (info) {
                                      _showModal(context, info);
                                    },
                                    // ignore: sort_child_properties_last
                                    child: const Icon(
                                      Icons.motorcycle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onOptionalButtonPressed: (inf) async {
                                      _showModalDetalles(context, inf);
                                    },
                                    showOptionalButton: true,
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
    ));
  }

  void _showModal(BuildContext context, Map<String, dynamic> info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: MyModalContent(
              domiciliariosList: domiciliariosList,
              informacion: info,
              opcion: 5),
        );
      },
    );
  }

  void _showModalDetalles(BuildContext context, inf) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: MyModalContentD(
          inf: inf,
        ));
      },
    );
  }
}
