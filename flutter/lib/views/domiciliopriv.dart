import 'package:conper/models/dimiciliopriv.dart';
import 'package:conper/views/components/modald.dart';
import 'package:conper/views/components/tabladomipriv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DomiciliosPriv extends StatefulWidget {
  const DomiciliosPriv({super.key});

  @override
  State<DomiciliosPriv> createState() => _DomiciliosPrivState();
}

class _DomiciliosPrivState extends State<DomiciliosPriv> {
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
                                      data: ordersTraza,
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
          ordersTraza.removeWhere(
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

  final TextEditingController _controller = TextEditingController();
  void modaltransferir(context, info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("Transferir a:"),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ID Domiciliario',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                await http
                    .put(Uri.parse('http://localhost:8080/transferir'),
                        body: json.encode({
                          "idDomiciiario": _controller.text,
                          "idPedido": info["idGeneral"],
                        }))
                    .then((response) {
                  if (response.statusCode == 200) {
                    setState(() {
                      ordersTraza.removeWhere((element) =>
                          element["idGeneral"] == info["idGeneral"]);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Se ha transferido el pedido'),
                      ),
                    );
                  }
                });
              },
              child: const Text("TRANSFERIR")),
        ]));
      },
    );
  }
}
