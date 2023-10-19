import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonthlyDataWidget extends StatefulWidget {
  @override
  _MonthlyDataWidgetState createState() => _MonthlyDataWidgetState();
}

class _MonthlyDataWidgetState extends State<MonthlyDataWidget> {
  List<Map<String, dynamic>> apiData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/datosgraficobarra'));
    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      if (parsedData['reporteMensual'] != null) {
        setState(() {
          apiData =
              List<Map<String, dynamic>>.from(parsedData['reporteMensual']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return apiData.isEmpty
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: apiData.map((data) {
                final mes = data['Mes'];
                final ventaEfectiva = data['VentaEfectiva'];
                final ventaCancelada = data['VentaCancelada'];
                final totalVenta = data['TotalVenta'];

                return Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes: $mes',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Venta Efectiva: $ventaEfectiva',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              )),
                          Text('Venta Cancelada: $ventaCancelada',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              )),
                          Text(
                            'Total Venta: $totalVenta',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
  }
}
