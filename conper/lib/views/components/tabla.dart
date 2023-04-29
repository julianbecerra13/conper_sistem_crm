import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Tabla extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> headers;
  final Function(int) onButtonPressed;
  final Widget child;
  // Funcion que ejecuta el boton. Tiene que poder acceder al id del row

  // el contenido que muestra el boton, puede ser icono o texto

  const Tabla(
      {Key? key,
      required this.data,
      required this.headers,
      required this.onButtonPressed,
      required this.child})
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
            decoration: BoxDecoration(
                color: rowData["NombreTraza"] == "Preparando"
                    ? const Color.fromARGB(255, 199, 255, 201)
                    : const Color.fromARGB(255, 255, 249, 194)),
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
                  child: Center(
                heightFactor: 1.5,
                widthFactor: 1.5,
                child: ElevatedButton(
                  onPressed: () {
                    onButtonPressed(rowData["idGeneral"]);
                  },
                  child: child,
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
