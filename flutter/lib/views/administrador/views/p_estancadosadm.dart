import 'dart:async';
import 'dart:convert';
import 'package:conper/views/administrador/views/components/tablaadm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import '../../../models/ordenes.dart';
import '../../components/modald.dart';

import 'components/menu.dart';

class PedidosEstancadosadm extends StatefulWidget {
  const PedidosEstancadosadm({Key? key}) : super(key: key);

  @override
  State<PedidosEstancadosadm> createState() => _PedidosState();
}

class _PedidosState extends State<PedidosEstancadosadm> {
  late List<Map<String, dynamic>> ordersTraza = [];
  List<Map<String, dynamic>> domiciliariosList = [];
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
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
    if (updatedOrders.length > ordersTraza.length) {
      setState(() {
        ordersTraza = updatedOrders;
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
        ordersTraza = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        'http://localhost:8080/pedidos?idCliente=${prefs.getString("login")}&idTraza=1&idPunto=${prefs.getInt("IDPunto")}'));
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
                            horizontal: 20.0, vertical: 10.0),
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "PEDIDOS ESTANCADOS",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
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
                                            "Titulo": 'Punto de venta',
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
                                        // ignore: non_constant_identifier_names
                                        onButtonPressed: (info) async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await http
                                              .put(
                                                  Uri.parse(
                                                      'http://localhost:8080/actualizarT'),
                                                  body: json.encode({
                                                    "idPunto":
                                                        prefs.getInt("IDPunto"),
                                                    "idPedido":
                                                        info["idGeneral"],
                                                    "idTraza": 2,
                                                  }))
                                              .then((response) {
                                            if (response.statusCode == 200) {
                                              //eliminar de la lista
                                              setState(() {
                                                ordersTraza.removeWhere(
                                                    (element) =>
                                                        element["idGeneral"] ==
                                                        info["idGeneral"]);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Pedido actualizado'),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        onOptionalButtonPressed: (inf) {
                                          _showModalDetalles(context, inf);
                                        },
                                        showOptionalButton: true,
                                        child: const Icon(
                                          Icons.arrow_downward,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
