import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TablaD extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> headers;

  const TablaD({
    Key? key,
    required this.data,
    required this.headers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          children: [
            ...headers.map(
              (cellData) => TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cellData["Titulo"],
                    style:const  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ...data.map(
          (rowData) => TableRow(
            children: [
              ...headers.map(
                (cellData) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(rowData[cellData["key"]].toString()),
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
