import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

class ReportesModal extends StatelessWidget {
  final String jsonResponse;

  const ReportesModal({Key? key, required this.jsonResponse}) : super(key: key);

  Future<void> generateAndDownloadExcel(BuildContext context) async {
    final newJsonResponse = json.decode(jsonResponse);

    if (newJsonResponse["data"] == null) {
      // Maneja el caso en el que no hay datos.
      return;
    }

    final excel = Excel.createExcel();
    final sheet = excel['Tabla de Datos'];

    // Agrega las cabeceras de las columnas
    sheet.appendRow(
        newJsonResponse["columns"].map((column) => column.toString()).toList());

    // Agrega los datos de la tabla
    for (var rowData in newJsonResponse["data"]) {
      sheet.appendRow(rowData.map((cell) => cell.toString()).toList());
    }

    if (html.window.navigator.userAgent.contains('Chrome')) {
      final List<int>? excelData = excel.encode();

      // Convierte los datos de Excel en una lista de bytes
      final blob = html.Blob([Uint8List.fromList(excelData!)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "tabla_datos.xlsx")
        ..click();

      // Revoca la URL creada para liberar recursos
      html.Url.revokeObjectUrl(url);

      // Notifica al usuario que el archivo se ha descargado correctamente.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Archivo Excel descargado con éxito.'),
        ),
      );
    } else {
      // Manejar el caso en el que el navegador no sea compatible
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('La descarga de Excel no es compatible con este navegador.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final newJsonResponse = json.decode(jsonResponse);

    if (newJsonResponse["data"] == null) {
      return AlertDialog(
        title: const Text("Tabla de Datos"),
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
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
          TextButton(
            onPressed: () => generateAndDownloadExcel(context),
            child: const Text("Descargar Excel"),
          ),
        ],
      );
    }
  }
}
