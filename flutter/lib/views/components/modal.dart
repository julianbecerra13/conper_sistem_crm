import 'dart:convert';
import 'package:conper/views/components/tabla.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

class MyModalContent extends StatelessWidget {
  final List<Map<String, dynamic>> domiciliariosList;
  final Map<String, dynamic> informacion;
  final int opcion;
  const MyModalContent(
      {super.key,
      required this.domiciliariosList,
      required this.informacion,
      required this.opcion});

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
                // ignore: prefer_const_constructors
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

                          // ignore: non_constant_identifier_names
                          onButtonPressed: (Domicilio) async {
                            if (informacion['idOrdenNumero'] == null) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await http
                                  .put(
                                      Uri.parse(
                                          'http://localhost:8080/actualizar'),
                                      body: json.encode({
                                        "idPunto": prefs.getInt("IDPunto"),
                                        "idPedido": informacion["idGeneral"],
                                        "idTraza": opcion,
                                        "idDomiciliario":
                                            Domicilio["idDomiciliario"]
                                      }))
                                  .then((response) {
                                if (response.statusCode == 200) {
                                  context.vRouter.to('/pedidos');
                                }
                              });
                            } else {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final idPunto = prefs.getInt('IDPunto');
                              final idOrdenNumero =
                                  informacion['idOrdenNumero'];

                              var request = http.Request(
                                  'POST',
                                  Uri.parse(
                                      'http://148.113.165.132:8080/webhooks/webhooks/data/ORDEREADY?idOrdenNumero=$idOrdenNumero&idPunto=$idPunto'));

                              http.StreamedResponse response =
                                  await request.send();

                              if (response.statusCode == 200) {
                                print(await response.stream.bytesToString());
                              } else {
                                print(response.reasonPhrase);
                              }
                              await http
                                  .put(
                                      Uri.parse(
                                          'http://localhost:8080/actualizar'),
                                      body: json.encode({
                                        "idPunto": prefs.getInt("IDPunto"),
                                        "idPedido": informacion["idGeneral"],
                                        "idTraza": opcion,
                                        "idDomiciliario":
                                            Domicilio["idDomiciliario"]
                                      }))
                                  .then((response) {
                                if (response.statusCode == 200) {
                                  context.vRouter.to('//p_estancados');
                                }
                              });
                            }
                          },
                          child: const Text("Asignarle el Pedido"),
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
