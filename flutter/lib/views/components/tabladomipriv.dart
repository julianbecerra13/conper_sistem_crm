import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TablaDomiPriv extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> headers;
  final Function(Map<String, dynamic>) onButtonPressed;
  final Function(Map<String, dynamic>)? onOptionalButtonPressed;
  final Widget child;
  final bool showOptionalButton;

  const TablaDomiPriv({
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
                padding: EdgeInsets.all(2.0),
                child: Text("finalizar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            if (showOptionalButton && onOptionalButtonPressed != null)
              const TableCell(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text("Detalle",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
          ],
        ),
        ...data.map(
          (rowData) => TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              // for each map
              ...headers.map(
                (cellData) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
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
                    child: const Icon(Icons.remove_red_eye),
                  ),
                ))
            ],
          ),
        ),
      ],
    );
  }
}
