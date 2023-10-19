import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class ReportesModal extends StatelessWidget {
  final String jsonResponse;

  const ReportesModal({super.key, required this.jsonResponse});

  @override
  Widget build(BuildContext context) {
    final newJsonResponse = json.decode(jsonResponse);

    if (newJsonResponse["data"] == null) {
      return AlertDialog(
        title: const  Text("Tabla de Datos"),
        content: const Text("Sin datos encontrados"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cerrar"),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: const Text("Tabla de Datos"),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Permite el desplazamiento vertical
          child: SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // Permite el desplazamiento horizontal
            child: DataTable(
              columns: newJsonResponse["columns"].map<DataColumn>((column) {
                return DataColumn(label: Text(column.toString()));
              }).toList(),
              rows: newJsonResponse["data"].map<DataRow>((rowData) {
                return DataRow(
                  cells: rowData.map<DataCell>((cell) {
                    return DataCell(Text(cell.toString()));
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              VRouter.of(context).to('/reportes');
            },
            child: const Text("Cerrar"),
          ),
        ],
      );
    }
  }
}
