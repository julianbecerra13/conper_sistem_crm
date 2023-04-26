import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Tabla extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Map<String,dynamic>> headers;
  // Funcion que ejecuta el boton. Tiene que poder acceder al id del row
  
  // el contenido que muestra el boton, puede ser icono o texto
  final Widget childButton;

  const Tabla({Key? key, required this.data, required this.headers, required this.childButton,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Colors.blue),
          children: [
            ...headers.map(
              (cellData) => TableCell(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(cellData["Titulo"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            ),
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Acciones",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
        ...data.map(
          (rowData) => TableRow(
            children: [
              // for each map
              ...headers.map(
                (cellData) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(rowData[cellData["key"]].toString()),
                  ),
                ),
              ),
              TableCell(
                 child: childButton,
              )
            ],
          ),
        ),
      ],
    );
  }
}