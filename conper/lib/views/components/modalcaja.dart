import 'dart:convert';

import 'package:conper/models/domiciliario.dart';
import 'package:conper/views/components/tabla.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Modaldomis extends StatefulWidget {
  const Modaldomis({Key? key}) : super(key: key);

  @override
  State<Modaldomis> createState() => _MyModalContentDState();
}

class _MyModalContentDState extends State<Modaldomis> {
  List<Map<String, dynamic>> domiciliariosList = [];

  @override
  void initState() {
    super.initState();
    getDomiciliarios();
  }

  void getDomiciliarios() async {
    await _getDomiciliarios().then((value) {
      setState(() {
        domiciliariosList = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getDomiciliarios() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://backend:8080/domiciliarios?idCliente=${prefs.getString("login")}&idTraza=${prefs.getInt("IDPunto")}'));
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SizedBox(
            width: 530,
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detalles",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                            {"Titulo": "Nombre", "key": "nombre"},
                            {
                              "Titulo": "ID Domiciliario",
                              "key": "idDomiciliario"
                            }
                          ],
                          onButtonPressed: (info) {
                            print(info);
                          },
                          child: const Text("Cuadre de Caja"),
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
