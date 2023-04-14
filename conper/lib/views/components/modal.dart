import 'package:flutter/material.dart';

class MyModalContent extends StatelessWidget {
  const MyModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //un padding para que el contenido del modal no este pegado a los bordes
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Datos del Domiciliaro', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16.0),
          //formulario de reguistro para los datos del domiciliario que serian los siguientes: nombre,cedula,placa,ceular
          //y un boton para guardar los datos
          Text('Nombre:'),
          SizedBox(
            width: 400,
            child: TextField(
              controller: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                hintText: 'Nombre',
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text('Cedula:'),
          TextField(
            controller: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: 'Cedula',
            ),
          ),
          SizedBox(height: 16.0),
          Text('Placa:'),
          TextField(
            controller: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: 'Placa',
            ),
          ),
          SizedBox(height: 16.0),
          Text('Celular:'),
          TextField(
            controller: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: 'Celular',
            ),
          ),
          SizedBox(height: 16.0),
          Text('Guardar'),
      
        ],
      ),
    );
  }
}
