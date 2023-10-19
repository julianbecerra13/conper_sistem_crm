import 'dart:async';
import 'package:conper/views/components/Reportesdomi.dart';
import 'package:flutter/material.dart';
import 'package:conper/models/dimiciliopriv.dart';
import 'package:conper/views/components/modald.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../models/domiciliario.dart';
import 'components/tabla.dart';
import 'components/tabladomipriv.dart';

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
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
      appBar: AppBar(
        title: const Text("CONPER DOMICILIARIO"),
        actions: [
          ElevatedButton(
            onPressed: () {
              modalreporte(context);
            },
            child: const Text(
              'Reporte',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () => _logOut(context),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 10.0),
                        child: Container(
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DOMICILIOS :",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Organiza las tarjetas en un ListView.builder
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: ListView.builder(
                                  itemCount: updatedOrdersTraza.length,
                                  itemBuilder: (context, index) {
                                    final rowData = updatedOrdersTraza[index];
                                    return TarjetaDomiPriv(
                                      data: rowData,
                                      onButtonPressed: (info) =>
                                          _showModal(context, info),
                                      onOptionalButtonPressed: (inf) =>
                                          _showModalDetalles(context, inf),
                                      showOptionalButton: true,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
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
            alignment: Alignment.center,
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
        double screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Margen agregado
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Pedido Finalizado como: ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      modaltransferir(context, info);
                    },
                    child: const Text("TRANSFERIR A OTRO DOMICILIARIO"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      int variable = 5;
                      Actualizar(variable, info);
                    },
                    child: const Text("ENTREGADO"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      int variable = 7;
                      Actualizar(variable, info);
                    },
                    child: const Text("NO ENTREGADO"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      int variable = 11;
                      Actualizar(variable, info);
                    },
                    child: const Text("POR CANCELAR"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      int variable = 13;
                      Actualizar(variable, info);
                    },
                    child: const Text("DEVOLUCION"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
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
        VRouter.of(context).to('/domiciliario');
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
        double screenHeight = MediaQuery.of(context).size.height;

        return AlertDialog(
          contentPadding:
              EdgeInsets.zero, // Elimina el padding interno del AlertDialog
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text("Transferir a:", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              SizedBox(
                height: screenHeight * 0.6, // Ajusta la altura del Card
                child: Card(
                  elevation: 8,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5),
                    child: Tabla(
                      data: domiciliariosList,
                      headers: const [
                        {"Titulo": "Nombre", "key": "nombre"},
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
                            VRouter.of(context).to('/domiciliario');
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
                      child: const Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 1, 52, 239),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void modalreporte(context) {
    TextEditingController inicioController = TextEditingController();
    TextEditingController finController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: const EdgeInsets.all(20.0), // Margen agregado
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Caja Punto",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: inicioController,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                hintText: 'Fecha Inicio aaaa-mm-dd',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: finController,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                hintText: 'Fecha Fin aaaa-mm-dd',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              String inicio = inicioController.text;
                              String fin = finController.text;
                              _showModalReporte(context, inicio, fin);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: const Text('Capture'),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showModalReporte(BuildContext context, inicio, fin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        double contentWidth = screenWidth * 0.8;
        double contentHeight = screenHeight * 0.8;

        // Ajusta el ancho y el alto del contenido en vista web
        if (screenWidth > 600) {
          contentWidth =
              screenWidth * 0.5; // Ajusta este valor según tus preferencias
          contentHeight =
              screenHeight * 0.5; // Ajusta este valor según tus preferencias
        }

        return AlertDialog(
          content: SizedBox(
            width: contentWidth,
            height: contentHeight,
            child: ReporteDomi(
              inicio: inicio,
              fin: fin,
            ),
          ),
        );
      },
    );
  }
}
