import 'package:conper/models/ordenes2.dart';
import 'package:conper/models/domiciliario.dart';
import 'package:conper/views/administrador/views/components/menu.dart';
import 'package:conper/views/components/modald.dart';
import 'package:conper/views/administrador/views/components/tablaadm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Domiciliosadm extends StatefulWidget {
  const Domiciliosadm({super.key});

  @override
  State<Domiciliosadm> createState() => _DomiciliosadmState();
}

class _DomiciliosadmState extends State<Domiciliosadm> {
  List<Map<String, dynamic>> ordersTraza = [];
  List<Map<String, dynamic>> domiciliariosList = [];

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

  void getDomiciliarios(idpunto) async {
    await _getDomiciliarios(idpunto).then((value) {
      setState(() {
        domiciliariosList = value;
      });
    });
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
          const MenuAdmin(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        "TRASABILIDAD",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
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
                                      child: Tablaadm(
                                        data: ordersTraza,
                                        headers: const [
                                          {
                                            "Titulo": 'ID orden',
                                            "key": "idGeneral"
                                          },
                                          {
                                            "Titulo": 'Numero de orden DIDI',
                                            "key": "IdOrdenNumero"
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
                                          getDomiciliarios(info["IdPunto"]);
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

  // ignore: non_constant_identifier_names
  void Actualizar(int variable, info) async {
    if (info["IdOrdenNumero"] == null) {
      await http
          .put(Uri.parse('http://localhost:8080/actualizarT'),
              body: json.encode({
                "idPunto": info["IdPunto"],
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
    } else {
      final idPunto = info['IdPunto'];
      final idOrdenNumero = info['idOrdenNumero'];

      final response = await http.post(
        Uri.parse(
            'http://148.113.165.132:8080/webhooks/webhooks/data/ORDERDELIVERED?idOrdenNumero=$idOrdenNumero&idPunto=$idPunto'),
      );
      if (response.statusCode == 200) {
        print('La solicitud fue exitosa');
      } else {
        print('La solicitud falló con el estado: ${response.statusCode}');
      }
      await http
          .put(Uri.parse('http://localhost:8080/actualizarT'),
              body: json.encode({
                "idPunto": info["IdPunto"],
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
                  child: Tablaadm(
                    data: domiciliariosList,
                    headers: const [
                      {"Titulo": "Nane", "key": "nombre"},
                      {"Titulo": "ID", "key": "idDomiciliario"}
                    ],
                    // ignore: non_constant_identifier_names
                    onButtonPressed: (Domicilio) async {
                      await http
                          .put(Uri.parse('http://localhost:8080/transferir'),
                              body: json.encode({
                                "idPedido": info["idGeneral"],
                                "idDomiciliario": Domicilio["idDomiciliario"],
                              }))
                          .then((response) {
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
