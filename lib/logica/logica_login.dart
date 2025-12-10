import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';

class Usuario {
  final String username;
  final String password;
  final String? totpSecret;

  Usuario({
    required this.username,
    required this.password,
    this.totpSecret,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      password: json['password'],
      totpSecret: json['totpSecret'],
    );
  }
}

class AutenticacionLogin {
  // Made public for testing
  List<Usuario> usuarios = [];
  Usuario? currentUser;

  Future<void> cargarUsuarios() async {
    final String jsonString =
        await rootBundle.loadString('assets/datos/usuarios.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    usuarios = jsonData.map((json) => Usuario.fromJson(json)).toList();
  }

  bool login(String username, String password) {
    try {
      currentUser = usuarios.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      return true;
    } catch (e) {
      currentUser = null;
      return false;
    }
  }

  bool requiresTOTP() {
    return currentUser?.totpSecret != null;
  }

  bool verifyTOTP(String code) {
    if (currentUser?.totpSecret == null) {
      return true; // No TOTP required
    }

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final generatedCode = OTP.generateTOTPCodeString(
        currentUser!.totpSecret!,
        now,
        length: 6,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      return code == generatedCode;
    } catch (e) {
      return false;
    }
  }
}
