import 'dart:convert';
import 'dart:async';
import 'package:conper/views/components/tablad.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vrouter/vrouter.dart';

import '../../models/reporteDomi.dart';

class ReporteDomi extends StatefulWidget {
  final dynamic inicio;
  final dynamic fin;

  const ReporteDomi({
    Key? key,
    required this.inicio,
    required this.fin,
  }) : super(key: key);

  @override
  State<ReporteDomi> createState() => _ReporteDomiState();
}

class _ReporteDomiState extends State<ReporteDomi> {
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
        'http://localhost:8080/reportepedidos?fechaInicio=$inicio&fechaFin=$fin&idDomiciliario=${prefs.getInt("IDUsuario")}'));
    List<dynamic> caja = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["reportePedidos"];
      if (data == null) {
        return [];
      }
      caja = data.map((i) => ReporteDomis.fromJson(i)).toList();
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
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Caja de Domiciliarios",
              style: TextStyle(
                fontSize: 24, // Ajusta el tamaño de fuente
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Espacio entre el título y la tabla
            Card(
              elevation: 8,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(5),
                child: TablaD(
                  data: cajaList2,
                  headers: const [
                    {"Titulo": 'Nombre', "key": "NombreMovil"},
                    {"Titulo": 'NombreP', "key": "NombrePunto"},
                    {"Titulo": '', "key": "TotalOP"},
                    {"Titulo": '', "key": "ValorFP"}
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10), // Espacio entre la tabla y el botón
            ElevatedButton(
              onPressed: () {
                VRouter.of(context).to('/domiciliario');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Cerrar Modal"),
            ),
          ],
        ),
      ),
    );
  }
}
