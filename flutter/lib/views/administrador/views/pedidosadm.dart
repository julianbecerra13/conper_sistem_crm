import 'dart:async';
import 'dart:convert';
import 'package:conper/views/administrador/views/components/menu.dart';
import 'package:conper/views/administrador/views/components/modaladm.dart';
import 'package:conper/views/administrador/views/components/tablaadm.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

import '../../../models/domiciliario.dart';
import '../../../models/ordenes.dart';
import '../../components/modald.dart';

class Pedidosadm extends StatefulWidget {
  const Pedidosadm({Key? key}) : super(key: key);

  @override
  State<Pedidosadm> createState() => _PedidosadmState();
}

class _PedidosadmState extends State<Pedidosadm> {
  List<Map<String, dynamic>> domiciliariosList = [];
  List<Map<String, dynamic>> updatedOrdersTraza = [];
  bool hasNewOrder = false;
  Timer? timer;

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
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkForNewOrder();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkForNewOrder() async {
    final updatedOrders = await _getOrders();
    if (updatedOrders.length > updatedOrdersTraza.length) {
      setState(() {
        updatedOrdersTraza = updatedOrders;
        hasNewOrder = true;
      });
      showToast();
    }
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: '¡Tienes un nuevo pedido!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  void getOrders() async {
    await _getOrders().then((value) {
      setState(() {
        updatedOrdersTraza = value;
      });
    });
  }

  void getDomiciliarios(idpunto) async {
    await _getDomiciliarios(idpunto).then((value) {
      setState(() {
        domiciliariosList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        'http://localhost:8080/pedidos?idCliente=${prefs.getString("login")}&idTraza=2&idPunto=${prefs.getInt("IDPunto")}'));
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

  Future<List<Map<String, dynamic>>> _getDomiciliarios(idpunto) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://localhost:8080/domiciliarios?idCliente=${prefs.getString("login")}&idTraza=$idpunto'));
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
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "PEDIDOS",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 250,
                                child: Card(
                                  elevation: 8,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(5),
                                    child: Tablaadm(
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
                                        {
                                          "Titulo": 'Punto',
                                          "key": "PuntodeVenta"
                                        },
                                        {
                                          "Titulo": 'Observaciones',
                                          "key": "Observaciones"
                                        },
                                        {
                                          "Titulo": 'Telefono',
                                          "key": "Telefono"
                                        },
                                      ],
                                      onButtonPressed: (info) {
                                        _showModal(context, info);
                                        getDomiciliarios(info["IdPunto"]);
                                      },
                                      onOptionalButtonPressed: (inf) async {
                                        _showModalDetalles(context, inf);
                                      },
                                      showOptionalButton: true,
                                      child: const Icon(
                                        Icons.motorcycle,
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

  void _showModal(BuildContext context, Map<String, dynamic> info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: MyModalContentadm(
            domiciliariosList: domiciliariosList,
            informacion: info,
            opcion: 5,
          ),
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
          ),
        );
      },
    );
  }
}
