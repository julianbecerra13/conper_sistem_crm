import 'package:mysql1/mysql1.dart';

class DatabaseController {
  static final _instance = DatabaseController._internal();
  static DatabaseController get instance => _instance;

  late MySqlConnection _connection;

  final settings = ConnectionSettings(
    host: 'db4free.net',
    user: 'integration',
    password: 'integration',
    db: 'integration',
  );

  DatabaseController._internal() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    _connection = await MySqlConnection.connect(settings);
  }

  Future<bool> verificarCredenciales(String username, String password) async {
    final result = await _connection.query(
      'SELECT COUNT(*) AS count FROM usuarios_fom WHERE usuario = ? AND contrasena = ?',
      [username, password],
    );
    return result.first['count'] == 1;
  }

  // Agrega aquí otras funciones que necesites para interactuar con la base de datos

  Future<void> closeConnection() async {
    await _connection.close();
  }
}