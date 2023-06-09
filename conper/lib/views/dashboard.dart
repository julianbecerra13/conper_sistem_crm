import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conper/views/components/menu.dart';

// _logOut(context); // llamar a la función _logOut

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
          Menu(),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('Dashboard'),
                ElevatedButton(
                  onPressed: () {
                    _logOut(context);
                  },
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
