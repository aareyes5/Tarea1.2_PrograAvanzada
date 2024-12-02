
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/factura.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //quitar el banner de debug
      title: 'Compra de Zapatos',
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/home': (context) => Home(),
        '/factura': (context) => Factura(),
      },
    );
  }
}