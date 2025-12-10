import 'package:flutter/material.dart';
import '../logica/logica_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AutenticacionLogin _auth = AutenticacionLogin();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _totpController = TextEditingController();
  String _errorMessage = '';
  bool _showTOTP = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      await _auth.cargarUsuarios();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar usuarios. Intente de nuevo.';
      });
    }
  }

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (_auth.login(username, password)) {
      if (_auth.requiresTOTP()) {
        setState(() {
          _showTOTP = true;
          _errorMessage = '';
        });
      } else {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      setState(() {
        _errorMessage = 'Usuario o contraseña incorrectos';
        _showTOTP = false;
      });
    }
  }

  void _verifyTOTP() {
    final totpCode = _totpController.text;

    if (_auth.verifyTOTP(totpCode)) {
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Código TOTP incorrecto';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE5E5E5), Color(0xFFFFFFFF)],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _showTOTP ? 'Autenticación 2FA' : 'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                if (!_showTOTP) ...[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _login,
                    icon: Icon(Icons.login),
                    label: Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE63946),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
                if (_showTOTP) ...[
                  Text(
                    'Ingrese el código de autenticación de 6 dígitos',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _totpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Código TOTP',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _verifyTOTP,
                    icon: Icon(Icons.verified_user),
                    label: Text('Verificar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE63946),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showTOTP = false;
                        _totpController.clear();
                        _usernameController.clear();
                        _passwordController.clear();
                        _errorMessage = '';
                      });
                    },
                    child: Text('Cancelar'),
                  ),
                ],
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}