import 'package:conper/views/administrador/views/components/cajacuadreadm.dart';
import 'package:conper/views/administrador/views/components/tablaadm.dart';
import 'package:conper/views/administrador/views/pqrsadm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../models/Punto.dart';

class MenuAdmin extends StatefulWidget {
  const MenuAdmin({Key? key}) : super(key: key);

  @override
  State<MenuAdmin> createState() => _MenuState();
}

class _MenuState extends State<MenuAdmin> {
  String nombrePunto = ''; // Variable para almacenar el nombre del punto
  int cantidadSinImpuestos = 0;
  int cantidadTotal = 0;
  int cantidadEnGestion = 0;
  int cantidadEnMovil = 0;
  late Timer _timer;
  List<Map<String, dynamic>> ordersPuntos = [];

  @override
  void initState() {
    super.initState();
    getPuntos();
    getNombrePunto();
    obtenerCantidadSinImprimir();
    obtenerCantidadTotal();
    obtenerCantidadEnGestion();
    obtenerCantidadEnMovil();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      obtenerCantidadSinImprimir();
      obtenerCantidadTotal();
      obtenerCantidadEnGestion();
      obtenerCantidadEnMovil();
    });
  }

  void getPuntos() async {
    await _getPuntos().then((value) {
      setState(() {
        ordersPuntos = value;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela el temporizador al liberar el widget
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _getPuntos() async {
    final response = await http.get(Uri.parse('http://localhost:8080/puntos'));
    List<dynamic> orders = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["reportes"];
      if (data == null) {
        return [];
      }
      orders = data.map((order) => Punto.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }

    List<Map<String, dynamic>> orderMap = [];

    for (var order in orders) {
      orderMap.add(order.toJson());
    }
    return orderMap;
  }

  void obtenerCantidadSinImprimir() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/cantidadsinimp'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Accede a la lista "numero" y obtén el primer elemento
        final numeroList = jsonData['numero'] as List<dynamic>;

        if (numeroList.isNotEmpty) {
          // Obtén el valor "Numero" del primer elemento de la lista
          final nuevaCantidad = numeroList[0]['Numero'] as int;

          setState(() {
            cantidadSinImpuestos = nuevaCantidad;
          });
        } else {
          // Manejar el caso en que la lista esté vacía
          print('La lista "numero" está vacía en el JSON');
        }
      } else {
        // Manejar el caso en que la solicitud no sea exitosa
        print('Error en la solicitud HTTP');
      }
    } catch (e) {
      // Manejar errores, como problemas de conexión
      print('Error al obtener la cantidad: $e');
    }
  }

  void obtenerCantidadTotal() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/cantidadTotal'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Accede al valor "CantidadTotal" en el JSON
        final numeroList = jsonData['numero'] as List<dynamic>;

        if (numeroList.isNotEmpty) {
          // Obtén el valor "Numero" del primer elemento de la lista
          final nuevaCantidadTotal = numeroList[0]['Numero'] as int;

          setState(() {
            cantidadTotal = nuevaCantidadTotal;
          });
        } else {
          // Manejar el caso en que la lista esté vacía
          print('La lista "numero" está vacía en el JSON');
        }
      } else {
        // Manejar el caso en que la solicitud no sea exitosa
        print('Error en la solicitud HTTP de cantidadTotal');
      }
    } catch (e) {
      // Manejar errores, como problemas de conexión
      print('Error al obtener cantidadTotal: $e');
    }
  }

  void obtenerCantidadEnGestion() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/cantidadEnGestion'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Accede al valor "CantidadTotal" en el JSON
        final numeroList = jsonData['numero'] as List<dynamic>;

        if (numeroList.isNotEmpty) {
          // Obtén el valor "Numero" del primer elemento de la lista
          final nuevaCantidadEnGestion = numeroList[0]['Numero'] as int;

          setState(() {
            cantidadEnGestion = nuevaCantidadEnGestion;
          });
        } else {
          // Manejar el caso en que la lista esté vacía
          print('La lista "numero" está vacía en el JSON');
        }
      } else {
        // Manejar el caso en que la solicitud no sea exitosa
        print('Error en la solicitud HTTP de cantidadTotal');
      }
    } catch (e) {
      // Manejar errores, como problemas de conexión
      print('Error al obtener cantidadTotal: $e');
    }
  }

  void obtenerCantidadEnMovil() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/cantidadMovil'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Accede al valor "CantidadTotal" en el JSON
        final numeroList = jsonData['numero'] as List<dynamic>;

        if (numeroList.isNotEmpty) {
          // Obtén el valor "Numero" del primer elemento de la lista
          final nuevaCantidadEnMovil = numeroList[0]['Numero'] as int;

          setState(() {
            cantidadEnMovil = nuevaCantidadEnMovil;
          });
        } else {
          // Manejar el caso en que la lista esté vacía
          print('La lista "numero" está vacía en el JSON');
        }
      } else {
        // Manejar el caso en que la solicitud no sea exitosa
        print('Error en la solicitud HTTP de cantidadTotal');
      }
    } catch (e) {
      // Manejar errores, como problemas de conexión
      print('Error al obtener cantidadTotal: $e');
    }
  }

  void getNombrePunto() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString('nombre');
    setState(() {
      nombrePunto =
          nombre ?? ''; // Asigna el nombre del punto a la variable nombrePunto
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Drawer(
        elevation: 20,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            Container(
              height: 20,
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 129, 187, 244),
              ),
              child: Text(
                nombrePunto, // Usa la variable nombrePunto aquí
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(158, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Añadido para distribuir el espacio
                  children: [
                    Flexible(
                      // Utilizado para el texto para que se ajuste automáticamente
                      child: Text(
                        'Dashboard', // Texto que aparece primero
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                leading: const Icon(Icons.dashboard, color: Colors.blue),
                onTap: () {
                  VRouter.of(context).to('/dashboard');
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(158, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Añadido para distribuir el espacio
                  children: [
                    const Flexible(
                      // Utilizado para el texto para que se ajuste automáticamente
                      child: Text(
                        'Trasabilidad', // Texto que aparece primero
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.red, // Fondo rojo del círculo
                        shape: BoxShape.circle, // Forma del círculo
                      ),
                      child: Center(
                        child: Text(
                          cantidadTotal
                              .toString(), // Número 1 que aparece en el círculo
                          style: const TextStyle(
                            color: Colors.black, // Color del número (negro)
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                leading:
                    const Icon(Icons.arrow_circle_right, color: Colors.blue),
                onTap: () {
                  VRouter.of(context).to('/administrador');
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(158, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Añadido para distribuir el espacio
                  children: [
                    const Flexible(
                      // Utilizado para el texto para que se ajuste automáticamente
                      child: Text(
                        'Pedidos Estancados', // Texto que aparece primero
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.red, // Fondo rojo del círculo
                        shape: BoxShape.circle, // Forma del círculo
                      ),
                      child: Center(
                        child: Text(
                          cantidadSinImpuestos
                              .toString(), // Número 1 que aparece en el círculo
                          style: const TextStyle(
                            color: Colors.black, // Color del número (negro)
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                leading: const Icon(Icons.dangerous, color: Colors.red),
                onTap: () {
                  VRouter.of(context).to('/estancadosadmin');
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(158, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Añadido para distribuir el espacio
                        children: [
                          const Flexible(
                            // Utilizado para el texto para que se ajuste automáticamente
                            child: Text(
                              'Pedidos', // Texto que aparece primero
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red, // Fondo rojo del círculo
                              shape: BoxShape.circle, // Forma del círculo
                            ),
                            child: Center(
                              child: Text(
                                cantidadEnGestion
                                    .toString(), // Número 1 que aparece en el círculo
                                style: const TextStyle(
                                  color:
                                      Colors.black, // Color del número (negro)
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.food_bank),
                      onTap: () {
                        VRouter.of(context).to('/pedidosadmin');
                      },
                    ),
                    // divider
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Añadido para distribuir el espacio
                        children: [
                          const Flexible(
                            // Utilizado para el texto para que se ajuste automáticamente
                            child: Text(
                              'Domicilios', // Texto que aparece primero
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red, // Fondo rojo del círculo
                              shape: BoxShape.circle, // Forma del círculo
                            ),
                            child: Center(
                              child: Text(
                                cantidadEnMovil
                                    .toString(), // Número 1 que aparece en el círculo
                                style: const TextStyle(
                                  color:
                                      Colors.black, // Color del número (negro)
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.delivery_dining),
                      onTap: () {
                        VRouter.of(context).to('/domiciliosadmin');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  _showModalPuntoscuadres(context, ordersPuntos);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Cuadre de Cajas"),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  _showModalPuntos(context, ordersPuntos);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Archivo Post"),
              ),
            ),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 243, 117),
                border: Border.all(
                  color: const Color.fromARGB(255, 33, 243, 117),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  _showModalPuntospqrs(context, ordersPuntos);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("PQRS"),
              ),
            ),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 243, 117),
                border: Border.all(
                  color: const Color.fromARGB(255, 33, 243, 117),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  VRouter.of(context).to('/reportes');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: const Text("Reportes"),
              ),
            )
          ],
        ),
      ),
    );
  }

  final TextEditingController fechaController = TextEditingController();

  void _showModalArchivoPost(BuildContext context, idpunto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Archivo Post",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      elevation: 8,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: fechaController,
                                        decoration: const InputDecoration(
                                          labelText: 'Fecha Formato aaaa-mm-dd',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese la Fecha';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await http
                                              .put(
                                            Uri.parse(
                                              'http://localhost:8080/archivopost',
                                            ),
                                            body: json.encode({
                                              "FechaInicio":
                                                  fechaController.text,
                                              "IDPunto": idpunto,
                                            }),
                                          )
                                              .then((response) {
                                            if (response.statusCode == 200) {
                                              Navigator.pop(context);
                                              _showModalresponse(
                                                  context, response);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Algo anda mal...',
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.blue,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              'Generar Archivo POST',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showModalresponse(BuildContext context, response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text("${response.body}"),
              const SizedBox(height: 10),
              const Text(
                "Recuerda revisar la ruta donde se almacena los archivos POST",
              ),
            ],
          ),
        );
      },
    );
  }

  void _showModalCuadre(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("selecionare el punto para hacer el cuadre"),
            ],
          ),
        );
      },
    );
  }

  void _showModalPuntos(BuildContext context, ordersPuntos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Selecionar el Punto para Generar el Archivo Post"),
              SizedBox(
                height: 400,
                width: 300,
                child: Card(
                  elevation: 8,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5),
                    child: Tablaadm(
                      data: ordersPuntos,
                      headers: const [
                        {"Titulo": 'Id', "key": "Id"},
                        {"Titulo": 'Nombre', "key": "Nombre"},
                      ],
                      // ignore: non_constant_identifier_names
                      onButtonPressed: (info) async {
                        var idpunto = info['Id'];
                        _showModalArchivoPost(context, idpunto);
                      },
                      showOptionalButton: false,
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
        );
      },
    );
  }

  void _showModalPuntoscuadres(BuildContext context, ordersPuntos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("selecionar el punto para hacer el cuadre"),
              SizedBox(
                height: 400,
                width: 300,
                child: Card(
                  elevation: 8,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5),
                    child: Tablaadm(
                      data: ordersPuntos,
                      headers: const [
                        {"Titulo": 'Id', "key": "Id"},
                        {"Titulo": 'Nombre', "key": "Nombre"},
                      ],
                      // ignore: non_constant_identifier_names
                      onButtonPressed: (info) async {
                        var idpunto = info['Id'];
                        _showModalPuntoCuadre(context, idpunto);
                      },
                      showOptionalButton: false,
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
        );
      },
    );
  }
  void _showModalPuntospqrs(BuildContext context, ordersPuntos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Selecionar el Punto para Generar el Archivo Post"),
              SizedBox(
                height: 400,
                width: 300,
                child: Card(
                  elevation: 8,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5),
                    child: Tablaadm(
                      data: ordersPuntos,
                      headers: const [
                        {"Titulo": 'Id', "key": "Id"},
                        {"Titulo": 'Nombre', "key": "Nombre"},
                      ],
                      // ignore: non_constant_identifier_names
                      onButtonPressed: (info) async {
                        var idpunto = info['Id'];
                        Pqrsadm(idpunto);
                      },
                      showOptionalButton: false,
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
        );
      },
    );
  }

  // ignore: unused_element
  void _showModall2(BuildContext context, inicio, fin, idPunto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Cajacuadreadm(
            inicio: inicio,
            fin: fin,
            idPunto: idPunto,
          ),
        );
      },
    );
  }

  void _showModalPuntoCuadre(BuildContext context, idpunto) {
    TextEditingController inicioController = TextEditingController();
    TextEditingController finController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Caja Punto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ignore: sized_box_for_whitespace
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 1000,
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
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 1000,
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
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              String inicio = inicioController.text;
                              String fin = finController.text;
                              _showModall2(context, inicio, fin, idpunto);
                            },
                            child: const Text('Capture'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
