import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:conper/models/dimiciliopriv.dart';
import 'package:conper/views/components/modald.dart';
import 'package:conper/views/components/tabladomipriv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../models/domiciliario.dart';
import 'components/tabla.dart';

class DomiciliosPriv extends StatefulWidget {
  const DomiciliosPriv({super.key});

  @override
  State<DomiciliosPriv> createState() => _DomiciliosPrivState();
}

class _DomiciliosPrivState extends State<DomiciliosPriv> {
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
    getDomiciliarios();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkForNewOrder();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  // ignore: unused_element
  Future<List<Map<String, dynamic>>> _getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        'http://localhost:8080/PedidosDomi?&idDomiciliario=${prefs.getInt("IDUsuario")}&idPunto=${prefs.getInt("IDPunto")}'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["pedidos"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => DomiPriv.fromJson(order)).toList();
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
        'http://localhost:8080/domiciliarios?idCliente=${prefs.getString("login")}&idTraza=${prefs.getInt("IDPunto")}'));
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        "Bienvenido a Conper Domiciliario",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 160,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                  const SizedBox(height: 20),
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 5.0),
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DOMICILIOS",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 250,
                                child: Card(
                                  child: SingleChildScrollView(
                                    child: TablaDomiPriv(
                                      data: updatedOrdersTraza,
                                      headers: const [
                                        {
                                          "Titulo": 'ID Pedido',
                                          "key": "idGeneral"
                                        },
                                        {"Titulo": 'Nombre', "key": "Nombre"},
                                        {
                                          "Titulo": 'Telefono',
                                          "key": "Telefono"
                                        },
                                        {
                                          "Titulo": 'Direccion',
                                          "key": "Direccion"
                                        },
                                        {
                                          "Titulo": 'Total Orden',
                                          "key": "TotalOrden"
                                        },
                                        {
                                          "Titulo": 'Fecha Creacion',
                                          "key": "FechaCrea"
                                        }
                                      ],
                                      // ignore: non_constant_identifier_names
                                      onButtonPressed: (info) async {
                                        _showModal(context, info);
                                      },
                                      onOptionalButtonPressed: (inf) {
                                        _showModalDetalles(context, inf);
                                      },
                                      showOptionalButton: true,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
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

  void _showModal(BuildContext context, info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Row(children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                const Text(
                  "Pedido Finalizado como: ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      modaltransferir(context, info);
                    },
                    child: const Text("TRANSFERIR A OTRO DOMICILIARIO")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      int variable = 5;
                      Actualizar(variable, info);
                    },
                    child: const Text("ENTREGADO")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      int variable = 7;
                      Actualizar(variable, info);
                    },
                    child: const Text("NO ENTREGADO")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      int variable = 11;
                      Actualizar(variable, info);
                    },
                    child: const Text("POR CANCELAR")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      int variable = 13;
                      Actualizar(variable, info);
                    },
                    child: const Text("DEVOLUCION")),
              ])),
        ]));
      },
    );
  }

  Actualizar(int variable, info) async {
    final prefs = await SharedPreferences.getInstance();
    await http
        .put(Uri.parse('http://localhost:8080/actualizarT'),
            body: json.encode({
              "idPunto": prefs.getInt("IDPunto"),
              "idPedido": info["idGeneral"],
              "idincidente": variable,
              "idTraza": 6,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          updatedOrdersTraza.removeWhere(
              (element) => element["idGeneral"] == info["idGeneral"]);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se ha actualizado el estado del pedido'),
          ),
        );
      }
    });
  }

  void modaltransferir(context, info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("Transferir a:"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Card(
                elevation: 8,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Tabla(
                    data: domiciliariosList,
                    headers: const [
                      {"Titulo": "Nane", "key": "nombre"},
                      {"Titulo": "ID", "key": "idDomiciliario"}
                    ],
                    onButtonPressed: (Domicilio) async {
                      await http
                          .put(Uri.parse('http://localhost:8080/transferir'),
                              body: json.encode({
                                "idPedido": info["idGeneral"],
                                "idDomiciliario": Domicilio["idDomiciliario"],
                              }))
                          .then((response) {
                        print(response.body);
                        if (response.statusCode == 200) {
                          VRouter.of(context).to('/domicilios');
                          setState(() {
                            updatedOrdersTraza.removeWhere((element) =>
                                element["idGeneral"] == info["idGeneral"]);
                          });
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(); // Cerrar el SnackBar actual
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Se ha asignado el pedido"),
                            ),
                          );
                        
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No se ha asignado el pedido"),
                            ),
                          );
                        }
                      });
                    },
                    child: const Text("Transferir"),
                  ),
                ),
              ),
            ),
          ),
        ]));
      },
    );
  }
}
