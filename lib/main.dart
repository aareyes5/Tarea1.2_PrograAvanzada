
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'pages/kilos.dart';
import 'pages/home.dart';



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
        '/': (context) => Home(),
        '/kilos': (context) => Kilos(),
      },
    );
  }
}