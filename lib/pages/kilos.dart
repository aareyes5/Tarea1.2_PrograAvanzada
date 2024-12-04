import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';

class Kilos extends StatefulWidget {
  @override
  _LoginPageState createState() => KilosState();
}

class KilosPageState extends State<Kilos> {

  final _controller = TextEditingController();
  LogicaKilos? _logicaKilos;
  String _mensaje = "Ingrese el límite de kilogramos para iniciar.";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _iniciarPrograma(String limite) {
    if (limite.isNotEmpty) {
      setState(() {
        _logicaKilos = LogicaKilos(int.parse(limite));
        _mensaje = "Ingrese los kilogramos pescados.";
      });
    }
  }

  void _agregarKilos(String kilos) {
    if (_logicaKilos == null) return;

    if (kilos.isNotEmpty) {
      final int kg = int.parse(kilos);
      final resultado = _logicaKilos!.agregarKilos(kg);

      setState(() {
        _mensaje = resultado;
        if (kg == 0) {
          _logicaKilos = null; // Resetear el programa si se introduce 0
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Pesca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _mensaje,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _logicaKilos == null
                    ? 'Ingrese el límite de kilogramos'
                    : 'Ingrese kilos pescados',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_logicaKilos == null) {
                  _iniciarPrograma(_controller.text);
                } else {
                  _agregarKilos(_controller.text);
                }
                _controller.clear();
              },
              child: Text(
                _logicaKilos == null ? 'Iniciar' : 'Agregar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
