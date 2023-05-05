import 'dart:convert';

import 'package:conper/views/components/tabla.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/domiciliario.dart';

class MyModalContent extends StatelessWidget {
  final List<Map<String, dynamic>> domiciliariosList;
  const MyModalContent({super.key, required this.domiciliariosList});  

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Domiciliarios",
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: Tabla(
                        data: domiciliariosList,
                        headers: const [
                          {"Titulo": "Nombre", "key": "nombre"},
                          {"Titulo": "ID Domiciliario", "key": "idDomiciliario"}
                        ],
                        onButtonPressed: (ID) {

                        },
                        child: const Text("Asignarle el Pedido"),
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
