import 'package:flutter/material.dart';

class Tabla extends StatelessWidget {
  final List<List<String>> data;
  final List<String> headers;

  const Tabla({Key? key, required this.data, required this.headers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            ...headers.map(
              (cellData) => TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cellData),
                ),
              ),
            ),
          ],
        ),
        ...data.map(
          (rowData) => TableRow(
            children: [
              ...rowData.map(
                (cellData) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(cellData),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
