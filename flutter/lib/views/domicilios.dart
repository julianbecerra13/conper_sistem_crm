import 'package:conper/models/ordenes2.dart';
import 'package:conper/views/components/modald.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';
import 'package:vrouter/vrouter.dart';
import 'components/tabla.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Domicilios extends StatefulWidget {
  const Domicilios({super.key});

  @override
  State<Domicilios> createState() => _DomiciliosState();
}

class _DomiciliosState extends State<Domicilios> {
  List<Map<String, dynamic>> ordersTraza = [];
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

  // ignore: unused_element
  Future<List<Map<String, dynamic>>> _getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        'http://localhost:8080/domicilios?idCliente=${prefs.getString("login")}&idTraza=5&idPunto=${prefs.getInt("IDPunto")}'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["ordenes"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Ordenes2.fromJson(order)).toList();
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
                  const SizedBox(height: 20),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "DOMICILIOS",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // ElevatedButton(
                                  //   style: ButtonStyle(
                                  //       shape: MaterialStateProperty.all<
                                  //               RoundedRectangleBorder>(
                                  //           RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(10.0),
                                  //   ))),
                                  //   onPressed: () {
                                  //     _showModal(context);
                                  //   },
                                  //   child: const Padding(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: 18.0, vertical: 12.0),
                                  //     child: Text('Agg Domiciliario',
                                  //         style:
                                  //             TextStyle(color: Colors.white)),
                                  //   ),
                                  // ),
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
                                            "key": "NombreDomiciliario"
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
                          VRouter.of(context).to('/Domicilio');
                          setState(() {
                            ordersTraza.removeWhere((element) =>
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
