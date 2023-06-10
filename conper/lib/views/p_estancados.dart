import 'package:conper/views/components/modald.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';
import 'package:vrouter/vrouter.dart';
import 'components/tabla.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ordenes.dart';

// _logOut(context); // llamar a la función _logOut

class PedidosEstancados extends StatefulWidget {
  const PedidosEstancados({Key? key}) : super(key: key);

  @override
  State<PedidosEstancados> createState() => _PedidosState();
}

class _PedidosState extends State<PedidosEstancados> {
  late List<Map<String, dynamic>> ordersTraza = [];
  List<Map<String, dynamic>> domiciliariosList = [];

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
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 300,
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
        ));
      },
    );
  }
}
