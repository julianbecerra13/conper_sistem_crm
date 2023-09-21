import 'dart:convert';
import 'dart:async';
import 'package:conper/models/domi.dart';
import 'package:conper/models/ordenes2.dart';
import 'package:conper/views/administrador/views/components/menu.dart';
import 'package:conper/views/administrador/views/components/tablaadm.dart';
import 'package:conper/views/components/modald.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'package:http/http.dart' as http;

// _logOut(context); // llamar a la función _logOut

class Administrador extends StatefulWidget {
  const Administrador({super.key});

  @override
  State<Administrador> createState() => _AdministradorState();
}

class _AdministradorState extends State<Administrador> {
  List<Map<String, dynamic>> ordersTraza = [];
  List<Map<String, dynamic>> domis = [];

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
        'http://localhost:8080/domicilios?idCliente=${prefs.getString("login")}&idTraza=6&idPunto=${prefs.getInt("IDPunto")}'));
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "GENERAL",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                                    onPressed: () async {
                                      // ignore: unused_local_variable
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      var punto = prefs.getInt("IDPunto");
                                      // ignore: use_build_context_synchronously
                                      _showModal2(context, punto);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 12.0),
                                      child: Text('Agg Domiciliario',
                                          style:
                                              TextStyle(color: Colors.white)),
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
                                    margin: const EdgeInsets.all(10),
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
                                            "Titulo": 'Domiciliario',
                                            "key": "NombreDomiciliario"
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
                                        // ignore: avoid_types_as_parameter_names
                                        onButtonPressed: (inf) {
                                          _showModalDetalles(context, inf);
                                        },
                                        child: const Text("Detalles"),
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

  
  Future<List<Map<String, dynamic>>> _getDomis(value) async {
    final response = await http.put(
        Uri.parse('http://localhost:8080/aggdomiciliarios'),
        body: json.encode({"cedula": value}));
    List<dynamic> domi = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["domiciliarios"];
      if (data == null) {
        return [];
      }
      domi = data.map((i) => Domi.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load i');
    }

    List<Map<String, dynamic>> domiMap = [];

    for (var i in domi) {
      domiMap.add(i.toJson());
    }
    return domiMap;
  }

  final TextEditingController ccController = TextEditingController();
  void _showModal2(BuildContext context, punto) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Asigna o Crea un Domiciliario",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: sized_box_for_whitespace
                            Container(
                              width: MediaQuery.of(context).size.width - 1000,
                              child: TextField(
                                controller: ccController,
                                onSubmitted: (value) {
                                  setState(() {
                                    _getDomis(value).then((info) {
                                      setState(() {
                                        domis = info;
                                      });
                                    });
                                  });
                                },
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Cedula...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                                onPressed: () {
                                  _showModalForm(context);
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Crear un Domiciliario")),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 800,
                          height: MediaQuery.of(context).size.height - 300,
                          child: Card(
                            elevation: 8,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Tablaadm(
                                data: domis,
                                headers: const [
                                  {"Titulo": 'Nombre', "key": 'Nombre'},
                                  {
                                    "Titulo": 'Identificacion',
                                    "key": 'Identificacion'
                                  },
                                  {"Titulo": 'Telefono', "key": 'Telefono'},
                                  {"Titulo": 'Punto', "key": 'IdPunto'},
                                ],
                                onButtonPressed: (informacion) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await http
                                      .put(
                                          Uri.parse(
                                              'http://localhost:8080/aggdomiciliariosn2'),
                                          body: json.encode({
                                            "Nivel": "2",
                                            "cedula":
                                                informacion['Identificacion'],
                                            "Nombre": informacion['Nombre'],
                                            "Telefono": informacion['Telefono'],
                                            "idPunto": prefs.getInt('IDPunto'),
                                          }))
                                      .then((response) {
                                    if (response.statusCode == 200) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Domiciliario Agregado')));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Error al agregar domiciliario')));
                                    }
                                  });
                                },
                                child: const Text("Asignar al Punto"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  final GlobalKey<FormState> _keyFrom = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  void _showModalForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
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
                      "Formulario del Domiciliario",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      elevation: 8,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _keyFrom,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Agrega los Datos del Domiciliario',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: nombreController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor ingrese su Nombre';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Nombre'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: cedulaController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor ingrese la Cedula de Ciudadania';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Cedula de Ciudadania'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          controller: telefonoController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor ingrese el numero de Telefono';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Telefono'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await http
                                                .put(
                                                    Uri.parse(
                                                        'http://localhost:8080/aggdomiciliariosn2'),
                                                    body: json.encode({
                                                      "Nivel": "3",
                                                      "cedula":
                                                          cedulaController.text,
                                                      "Nombre":
                                                          nombreController.text,
                                                      "Telefono":
                                                          telefonoController
                                                              .text,
                                                      "idPunto": prefs
                                                          .getInt('IDPunto'),
                                                    }))
                                                .then((response) {
                                              if (response.statusCode == 200) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Domiciliario Creado y Asignado al Punto')));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Error al Crear y Asignar el Domiciliario al Punto')));
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
                                                'Agregar Domiciliario',
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
                    ),
                  ],
                ),
              );
            }),
          );
        });
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
