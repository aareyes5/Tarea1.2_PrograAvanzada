import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AutenticacionLogin _auth = AutenticacionLogin();
  late Future<void> _cargarUsuariosFuture;

  @override
  void initState() {
    super.initState();
    // Inicia la carga de usuarios
    _cargarUsuariosFuture = _auth.cargarUsuarios();
  }

  void _login() {
    if (_auth.login(_usernameController.text, _passwordController.text)) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: FutureBuilder<void>(
        future: _cargarUsuariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se cargan los usuarios
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Maneja errores en la carga del archivo JSON
            return Center(child: Text('Error al cargar usuarios'));
          } else {
            // Construye la interfaz de login después de cargar los usuarios
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Usuario'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Iniciar sesión'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
