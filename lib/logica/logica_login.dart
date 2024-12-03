import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:flutter/services.dart';


//Clase que se encarga de la autenticacion de los usuarios
class Usuario {
  final String username;
  final String password;

  Usuario({required this.username, required this.password});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      password: json['password'],
    );
  }
}

class AutenticacionLogin {
  final List<Usuario> _usuarios = [];

  Future<void> cargarUsuarios() async {
    try {
      // Usamos rootBundle para cargar el archivo desde assets
      final String jsonString = await rootBundle.loadString('assets/datos/usuarios.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);

      _usuarios.clear();
      _usuarios.addAll(jsonData.map((user) => Usuario.fromJson(user)).toList());
    } catch (e) {
      print('Error cargando usuarios: $e');
    }
  }

  bool login(String username, String password) {
    for (final usuario in _usuarios) {
      if (usuario.username == username && usuario.password == password) {
        return true;
      }
    }
    return false;
  }
}