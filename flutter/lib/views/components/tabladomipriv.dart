import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TarjetaDomiPriv extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onButtonPressed;
  final Function(Map<String, dynamic>)? onOptionalButtonPressed;
  final Widget child;
  final bool showOptionalButton;

  const TarjetaDomiPriv({
    Key? key,
    required this.data,
    required this.onButtonPressed,
    this.onOptionalButtonPressed,
    required this.child,
    this.showOptionalButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contenido de la tarjeta
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "ID Pedido: ${data["idGeneral"]}\n",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const TextSpan(
                    text: "Nombre: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "${data["Nombre"]}\n",
                  ),
                  const TextSpan(
                    text: "Telefono: ",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${data["Telefono"]}\n",
                  ),
                  const TextSpan(
                    text: "Direccion: ",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "Direccion: ${data["Direccion"]}\n",
                  ),
                  const TextSpan(
                    text: "Total Orden: ",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${data["TotalOrden"]}\n",
                  ),
                  const TextSpan(
                    text: "Fecha Creacion: ",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${data["FechaCrea"]}\n",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12), // Espacio entre texto y botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => onButtonPressed(data),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: child,
                ),
                if (showOptionalButton && onOptionalButtonPressed != null)
                  ElevatedButton(
                    onPressed: () => onOptionalButtonPressed!(data),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Icon(Icons.remove_red_eye),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
