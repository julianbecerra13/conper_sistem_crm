import 'dart:convert';
import 'dart:async';
import 'package:conper/models/cajapunto.dart';
import 'package:conper/views/components/tablad.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vrouter/vrouter.dart';

class Cajapunto extends StatefulWidget {
  final dynamic inicio;
  final dynamic fin;

  const Cajapunto({
    Key? key,
    required this.inicio,
    required this.fin,
  }) : super(key: key);

  @override
  State<Cajapunto> createState() => _cajapuntoState();
}

class _cajapuntoState extends State<Cajapunto> {
  List<Map<String, dynamic>> cajaList2 = [];

  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    VRouter.of(context).to('/');
  }

  @override
  void initState() {
    super.initState();
    getcajas();
  }

  void getcajas() async {
    await _getcajas(widget.inicio, widget.fin).then((value) {
      setState(() {
        cajaList2 = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getcajas(
      dynamic inicio, dynamic fin) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://localhost:8080/cuadrecajapunto?idUsuario=${prefs.getString("login")}&idPunto=${prefs.getInt("IDPunto")}&fechaInicio=$inicio&fechaFin=$fin'));
    
    List<dynamic> caja = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["cuadreCaja"];
      if (data == null) {
        return [];
      }
      caja = data.map((i) => CajaPunto.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load data');
    }

    List<Map<String, dynamic>> cajaMap = [];

    for (var i in caja) {
      cajaMap.add(i.toJson());
    }
    return cajaMap;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Caja de Domiciliarios",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    width: MediaQuery.of(context).size.width - 400,
                    child: Card(
                      elevation: 8,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: TablaD(
                          data: cajaList2,
                          headers: const [

                            {"Titulo": 'Nombre', "key": "NombrePunto"},
                            {"Titulo": 'Tipo de Pago', "key": "NombreTipoPago"},
                            {"Titulo": 'Total Ordenes', "key": "TotalOrdenes"},
                            {"Titulo": 'Total de ventas', "key": "TotalVenta"}
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cerrar Modal")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
