
import 'package:deudas/models/deuda.dart';
import 'package:deudas/screens/deudas_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Datos {
  
  static final Datos _instance = Datos._internal();
  Datos._internal(); 
  factory Datos() {
    return _instance;
  }

  late FlutterSecureStorage storage;

  Future<String> cargarDatos() async{
    storage = FlutterSecureStorage();
    final str = await storage.read(key: 'deudas') ?? ''; 
    return str;
  }

  salvarDatos(String value ) async {
    await storage.write(key: 'deudas', value: value);
  }
  
}