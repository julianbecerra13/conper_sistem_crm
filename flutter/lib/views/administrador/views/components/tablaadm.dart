import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Tablaadm extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> headers;
  final Function(Map<String, dynamic>) onButtonPressed;
  final Function(Map<String, dynamic>)? onOptionalButtonPressed;
  final Widget child;
  final bool showOptionalButton;

  const Tablaadm({
    Key? key,
    required this.data,
    required this.headers,
    required this.onButtonPressed,
    this.onOptionalButtonPressed,
    required this.child,
    this.showOptionalButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
      children: [
        TableRow(
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          children: [
            ...headers.map(
              (cellData) => TableCell(
                child: Padding(
                    padding: const EdgeInsets.all(6.0),
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
            ),
            if (showOptionalButton && onOptionalButtonPressed != null)
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Detalles",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
          ],
        ),
        ...data.map(
          (rowData) => TableRow(
            decoration: BoxDecoration(
              color: rowData["PuntodeVenta"] == "P.D.V. KR 30"
                  ? const Color.fromARGB(255, 185, 255, 188)
                  : rowData["PuntodeVenta"] == "P.D.V. CL 127"
                      ? const Color.fromARGB(255, 229, 184, 255)
                      : rowData["PuntodeVenta"] == "P.D.V. CENTRO"
                          ? const Color.fromARGB(255, 255, 185, 185)
                          : rowData["PuntodeVenta"] == "P.D.V. BOYACA"
                      ? const Color.fromARGB(255, 174, 195, 22)
                      :rowData["PuntodeVenta"] == "P.D.V. PALATINO"
                      ? const Color.fromARGB(255, 131, 227, 22)
                      :rowData["PuntodeVenta"] == "P.D.V. CL 170"
                      ? const Color.fromARGB(255, 212, 49, 35)
                      :rowData["PuntodeVenta"] == "P.D.V. PORTAL"
                      ? const Color.fromARGB(255, 200, 22, 138)
                      :rowData["PuntodeVenta"] == "P.D.V. LA CASTELLANA"
                      ? const Color.fromARGB(255, 58, 30, 218)
                      :rowData["PuntodeVenta"] == "P.D.V. PLAZA DE LAS AMERICAS"
                      ? const Color.fromARGB(255, 36, 193, 241)
                      :rowData["PuntodeVenta"] == "P.D.V. COLPATRIA"
                      ? const Color.fromARGB(255, 231, 190, 66)
                      :rowData["PuntodeVenta"] == "P.D.V. AVENIDA SUBA"
                      ? const Color.fromARGB(255, 0, 132, 33)
                      :rowData["PuntodeVenta"] == "P.D.V. FONTIBON"
                      ? const Color.fromARGB(255, 211, 22, 113)
                      :rowData["PuntodeVenta"] == "P.D.V. PLAZA IMPERIAL"
                      ? const Color.fromARGB(255, 6, 35, 255)
                      :rowData["PuntodeVenta"] == "P.D.V. CL 70 CON 11"
                      ? const Color.fromARGB(255, 6, 96, 181)
                      :rowData["PuntodeVenta"] == "P.D.V.CALLE 82"
                      ? const Color.fromARGB(255, 25, 159, 65)
                      :rowData["PuntodeVenta"] == "P.D.V. ALAMOS"
                      ? const Color.fromARGB(255, 40, 233, 18)
                      :rowData["PuntodeVenta"] == "P.D.V. 103"
                      ? const Color.fromARGB(255, 211, 218, 4)
                      : const Color.fromARGB(255, 184, 203, 255),
              borderRadius: BorderRadius.circular(10),
            ),
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
                  onPressed: () => onButtonPressed(rowData),
                  child: child,
                ),
              )),
              if (showOptionalButton && onOptionalButtonPressed != null)
                TableCell(
                    child: Center(
                  heightFactor: 1.5,
                  widthFactor: 1.5,
                  child: ElevatedButton(
                    onPressed: () => onOptionalButtonPressed!(rowData),
                    child: const Text("Detalles"),
                  ),
                ))
            ],
          ),
        ),
      ],
    );
  }
}
