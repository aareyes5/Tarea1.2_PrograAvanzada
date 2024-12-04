//Archivo donde se acumularan las clases que se usaran para calcular ymostrar el peso de los pescados
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';


class LogicaKilos {
  final int limite;
  int _totalKilos = 0;

  LogicaKilos(this.limite);

  int get totalKilos => _totalKilos;

  String agregarKilos(int kilos) {
    if (kilos == 0) {
      return "Programa terminado. Total pescado: $_totalKilos kg.";
    }

    if (_totalKilos + kilos > limite) {
      return "Límite excedido. No se pueden agregar más kilos.";
    }

    _totalKilos += kilos;
    return "Total pescado: $_totalKilos kg.";
  }
}


