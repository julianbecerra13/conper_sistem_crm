import 'dart:convert';
import 'dart:async';
import 'package:conper/models/cajadomi.dart';
import 'package:conper/views/components/tablad.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cajacuadreadm extends StatefulWidget {
  final dynamic inicio;
  final dynamic fin;
  final dynamic idPunto;

  const Cajacuadreadm({
    Key? key,
    required this.inicio,
    required this.fin,
    required this.idPunto,
  }) : super(key: key);

  @override
  State<Cajacuadreadm> createState() => _CajacuadreState();
}

class _CajacuadreState extends State<Cajacuadreadm> {
  List<Map<String, dynamic>> cajaList = [];

  @override
  void initState() {
    super.initState();
    getcajas();
  }

  void getcajas() async {
    await _getcajas(widget.inicio, widget.fin, widget.idPunto).then((value) {
      setState(() {
        cajaList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getcajas(
    dynamic inicio,
    dynamic fin,
    dynamic idPunto,
  ) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/cuadrecajadomi?&idPunto=$idPunto&fechaInicio=$inicio&fechaFin=$fin'));

    List<dynamic> caja = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["cuadreCaja"];
      if (data == null) {
        return [];
      }
      caja = data.map((i) => CajaDomis.fromJson(i)).toList();
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
                          data: cajaList,
                          headers: const [
                            {
                              "Titulo": 'Nombre Domiciliario',
                              "key": "nombreMovil"
                            },
                            {"Titulo": 'Punto', "key": "nombrePunto"},
                            {"Titulo": 'Tipo de Pago', "key": "nombreTipoPago"},
                            {"Titulo": 'Cantidad de Ventas', "key": "totalFP"},
                            {
                              "Titulo": 'Cantidad de Ordenes',
                              "key": "totalOrdenes"
                            },
                            {"Titulo": 'Total', "key": "valorFP"},
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
