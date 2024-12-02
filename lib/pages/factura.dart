import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';

class Factura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = ModalRoute.of(context)!.settings.arguments as List<String>;
   // final Pdftransform pdfTransform = Pdftransform();
/*
    Future<void> _generatePdf() async {
      final filePath = await pdfTransform.generateInvoice(items);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Factura guardada en $filePath')),
      );
    }
*/
    return Scaffold(
      appBar: AppBar(title: Text('Factura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artículos en el carrito:', style: TextStyle(fontSize: 18)),
            ...items.map((item) => Text('- $item')).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Guardar factura como PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
