import 'dart:async';
import 'dart:convert';
import 'package:conper/views/administrador/models/datosventas.dart';
import 'package:conper/views/administrador/views/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'package:http/http.dart' as http;

import 'components/graficabarras.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Map<String, dynamic>> ordersTraza = [];
  late List<Map<String, dynamic>> ordersTraza1 = [];
  late List<Map<String, dynamic>> ordersTraza2 = [];
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
    getOrders1();
    getOrders2();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      getOrders();
      getOrders1();
      getOrders2(); // Actualizar datos periódicamente
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getOrders() async {
    await _getOrders().then((value) {
      setState(() {
        ordersTraza = value;
      });
    });
  }

  void getOrders1() async {
    await _getOrders1().then((value) {
      setState(() {
        ordersTraza1 = value;
      });
    });
  }

  void getOrders2() async {
    await _getOrders2().then((value) {
      setState(() {
        ordersTraza2 = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getOrders() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/mensualventas'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["datos"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Datosventas.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }

    List<Map<String, dynamic>> orderMap = [];

    for (var order in orders) {
      orderMap.add(order.toJson());
    }
    return orderMap;
  }

  Future<List<Map<String, dynamic>>> _getOrders1() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/diarioventas'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["datos"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Datosventas.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }

    List<Map<String, dynamic>> orderMap = [];

    for (var order in orders) {
      orderMap.add(order.toJson());
    }
    return orderMap;
  }

  Future<List<Map<String, dynamic>>> _getOrders2() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/anualventas'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["datos"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Datosventas.fromJson(order)).toList();
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
                  Wrap(
                    spacing: 9,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      const Text(
                        "DASHBOARD",
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
                  const SizedBox(height: 10),
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
                          child: Column(children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "GRAFICOS GENERALES",
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
                                  margin: const EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Card(
                                              elevation: 30,
                                              color: const Color.fromARGB(
                                                  255, 221, 232, 241),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "Venta Diaria",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF1E3CFF),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          "${ordersTraza1.isNotEmpty ? ordersTraza1[0]['Totalventa'] : '0'}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "N.Pedidos",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF1E3CFF),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          "${ordersTraza1.isNotEmpty ? ordersTraza1[0]['TotalOrdenes'] : '0'}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 30,
                                              color: const Color.fromARGB(
                                                  255, 221, 232, 241),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "Venta Mensual",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF1E3CFF),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          "${ordersTraza.isNotEmpty ? ordersTraza[0]['Totalventa'] : '0'}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "N.Pedidos",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF1E3CFF),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          "${ordersTraza.isNotEmpty ? ordersTraza[0]['TotalOrdenes'] : '0'}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 30,
                                              color: const Color.fromARGB(
                                                  255, 221, 232, 241),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "Venta Anual",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF1E3CFF),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          "${ordersTraza2.isNotEmpty ? ordersTraza2[0]['Totalventa'] : '0'}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "N.Pedidos",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF1E3CFF),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          "${ordersTraza2.isNotEmpty ? ordersTraza2[0]['TotalOrdenes'] : '0'}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        const SizedBox(height: 30),
                                        const Text(
                                          "VENTAS MENSUALES",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 30),
                                        SizedBox(
                                          width: 1000,
                                          child: Center(
                                            child: SizedBox(
                                              height:
                                                  300, // Ajusta la altura según tus necesidades
                                              child: MonthlyDataWidget(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
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
}
