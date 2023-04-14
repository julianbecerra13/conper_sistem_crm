import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';
import 'components/modal.dart';
import 'components/tabla.dart';

// _logOut(context); // llamar a la función _logOut

class Pedidos extends StatelessWidget {
  const Pedidos({super.key});

  // función asincrónica para eliminar los datos de inicio de sesión
  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Menu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TRASABILIDAD",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 450,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Container(
                                height: 40,
                                child: const TextField(
                                controller: null,
                                decoration: InputDecoration(

                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  hintText: 'Buscar...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                              onPressed: () => _logOut(context),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 12.0),
                                child: Text('Cerrar sesión',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Flexible(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "PEDIDOS",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 300,
                                  child: const SingleChildScrollView(
                                    child: Tabla(
                                      data: [
                                        [
                                          '1',
                                          'Juan',
                                          'Calle 1',
                                          '10000',
                                          'Opcion'
                                        ],
                                        [
                                          '2',
                                          'Pedro',
                                          'Calle 2',
                                          '20000',
                                          'Opcion'
                                        ],
                                        [
                                          '3',
                                          'Maria',
                                          'Calle 3',
                                          '30000',
                                          'Opcion'
                                        ],
                                        [
                                          '4',
                                          'Luis',
                                          'Calle 4',
                                          '40000',
                                          'Opcion'
                                        ],
                                        [
                                          '5',
                                          'Camilo',
                                          'Calle 5',
                                          '50000',
                                          'Opcion'
                                        ],
                                        [
                                          '6',
                                          'Andres',
                                          'Calle 6',
                                          '60000',
                                          'Opcion'
                                        ],
                                        [
                                          '7',
                                          'Sofia',
                                          'Calle 7',
                                          '70000',
                                          'Opcion'
                                        ],
                                        [
                                          '8',
                                          'Julian',
                                          'Calle 8',
                                          '80000',
                                          'Opcion'
                                        ],
                                        [
                                          '9',
                                          'Santiago',
                                          'Calle 9',
                                          '90000',
                                          'Opcion'
                                        ],
                                        [
                                          '10',
                                          'Valentina',
                                          'Calle 10',
                                          '100000',
                                          'Opcion'
                                        ],
                                        [
                                          '11',
                                          'Mateo',
                                          'Calle 11',
                                          '110000',
                                          'Opcion'
                                        ],
                                        [
                                          '12',
                                          'Sebastian',
                                          'Calle 12',
                                          '120000',
                                          'Opcion'
                                        ],
                                        [
                                          '13',
                                          'Nicolas',
                                          'Calle 13',
                                          '130000',
                                          'Opcion'
                                        ],
                                        [
                                          '14',
                                          'Laura',
                                          'Calle 14',
                                          '140000',
                                          'Opcion'
                                        ],
                                        [
                                          '15',
                                          'Daniela',
                                          'Calle 15',
                                          '150000',
                                          'Opcion'
                                        ],
                                        [
                                          '16',
                                          'Isabella',
                                          'Calle 16',
                                          '160000',
                                          'Opcion'
                                        ],
                                        [
                                          '17',
                                          'Manuela',
                                          'Calle 17',
                                          '170000',
                                          'Opcion'
                                        ],
                                        [
                                          '18',
                                          'Jose',
                                          'Calle 18',
                                          '180000',
                                          'Opcion'
                                        ],
                                        [
                                          '19',
                                          'Alexandra',
                                          'Calle 19',
                                          '190000',
                                          'Opcion'
                                        ],
                                        [
                                          '20',
                                          'Sara',
                                          'Calle 20',
                                          '200000',
                                          'Opcion'
                                        ],
                                        [
                                          '21',
                                          'David',
                                          'Calle 21',
                                          '210000',
                                          'Opcion'
                                        ],
                                        [
                                          '22',
                                          'Juan',
                                          'Calle 22',
                                          '220000',
                                          'Opcion'
                                        ],
                                        [
                                          '23',
                                          'Pedro',
                                          'Calle 23',
                                          '230000',
                                          'Opcion'
                                        ],
                                        [
                                          '24',
                                          'Maria',
                                          'Calle 24',
                                          '240000',
                                          'Opcion'
                                        ],
                                        [
                                          '25',
                                          'Luis',
                                          'Calle 25',
                                          '250000',
                                          'Opcion'
                                        ],
                                        [
                                          '26',
                                          'Camilo',
                                          'Calle 26',
                                          '260000',
                                          'Opcion'
                                        ],
                                        [
                                          '27',
                                          'Andres',
                                          'Calle 27',
                                          '270000',
                                          'Opcion'
                                        ],
                                        [
                                          '28',
                                          'Sofia',
                                          'Calle 28',
                                          '280000',
                                          'Opcion'
                                        ],
                                        [
                                          '29',
                                          'Julian',
                                          'Calle 29',
                                          '290000',
                                          'Opcion'
                                        ],
                                        [
                                          '30',
                                          'Santiago',
                                          'Calle 30',
                                          '300000',
                                          'Opcion'
                                        ],
                                        [
                                          '31',
                                          'Valentina',
                                          'Calle 31',
                                          '310000',
                                          'Opcion'
                                        ],
                                        [
                                          '32',
                                          'Mateo',
                                          'Calle 32',
                                          '320000',
                                          'Opcion'
                                        ],
                                        [
                                          '33',
                                          'Sebastian',
                                          'Calle 33',
                                          '330000',
                                          'Opcion'
                                        ],
                                        [
                                          '34',
                                          'Nicolas',
                                          'Calle 34',
                                          '340000',
                                          'Opcion'
                                        ],
                                      ],
                                      headers: [
                                        'ID orden',
                                        'Nombre',
                                        'Direccion',
                                        'Total de la orden',
                                        'Opciones'
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
   void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AGREGAR DOMICILIARIO'),
          content: const MyModalContent(),
          actions: [
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
