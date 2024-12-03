import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pw;
import 'package:open_file/open_file.dart';

class Factura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = ModalRoute.of(context)!.settings.arguments as List<Productos>;
    final Pdftransform pdfTransform = Pdftransform();

    Future<void> _generatePdf() async {
      final filePath = await pdfTransform.generateInvoice(items);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Factura guardada en $filePath')),
      );
      OpenFile.open(filePath); // Abrir el archivo directamente
    }

    final double total = items.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: Text('Factura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artículos en el carrito:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ...items.map((item) => Text('${item.name}: \$${item.price}')),
            Divider(),
            Text('Valor Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generatePdf,
              child: Text('Guardar factura como PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

