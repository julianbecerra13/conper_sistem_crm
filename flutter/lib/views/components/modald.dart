import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:conper/models/detalles.dart';
import 'package:flutter/material.dart';
import 'package:conper/views/components/tablad.dart';

class MyModalContentD extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final inf;

  const MyModalContentD({Key? key, required this.inf}) : super(key: key);

  @override
  State<MyModalContentD> createState() => _MyModalContentDState();
}

class _MyModalContentDState extends State<MyModalContentD> {
  List<Map<String, dynamic>> detallesList = [];

  
  @override
  void initState() {
    super.initState();
    getDetalles();
  }

  void getDetalles() async {
    await _getDetalles().then((value) {
      setState(() {
        detallesList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getDetalles() async {
    final response = await http.put(
        Uri.parse('http://localhost:8080/detalles'),
        body: json.encode({"IdPedido":widget.inf["idGeneral"]}));
    List<dynamic> detalles = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["detalles"];
      detalles = data.map((detalle) => Detalles.fromJson(detalle)).toList();
    } else {
      throw Exception('Failed to load detalles');
    }

    List<Map<String, dynamic>> detallesMap = [];

    for (var detalle in detalles) {
      detallesMap.add(detalle.toJson());
    }
    return detallesMap;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
          child: SizedBox(
            width: 600,
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              children: [
                const Text(
                  "Detalles",
                  style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 250,
                    child: Card(
                      elevation: 8,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(5),
                        child: TablaD(
                          data: detallesList,
                          headers: const [
                            {
                              "Titulo": 'cantidad',
                              "key": "Cantidad",
                            
                            },
                            {
                              "Titulo": '',
                              "key": "ItemNombre",
                            
                            },
                            {
                              "Titulo": '',
                              "key": "ValorBaseUni",
                            },
                            {
                              "Titulo": '',
                              "key": "ValorTotal",
                            },
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
      ),
    );
  }
}
