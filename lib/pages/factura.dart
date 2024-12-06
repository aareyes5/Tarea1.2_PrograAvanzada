import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';
import 'package:pdf/widgets.dart' as pw;
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
      appBar: AppBar(
        title: Text('Factura'),
        backgroundColor: Color(0xFFE63946),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Artículos en el carrito:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              ...items.map(
                    (item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '${item.name}: \$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Divider(),
              Text(
                'Valor Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _generatePdf,
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Guardar factura como PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF4D03F),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
