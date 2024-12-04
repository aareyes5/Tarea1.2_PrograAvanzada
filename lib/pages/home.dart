import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';
//pantalla con mensaje de bienvenida y un boton que redirige a la pantalla de pesage de pescado

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenido a La pesa de pescado'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/kilos');
              },
              child: Text('Comprar zapatos'),
            ),
          ],
        ),
      ),
    );
  }

}
