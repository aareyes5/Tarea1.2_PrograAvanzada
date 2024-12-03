//Archivo donde se acumularan las clases que se usara la logica en varios haspectos de la aplicacion
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';

//Clase que se encarga del carrito de compra
class Carrito {
  final List<Productos> _items = [];

  void addToCart(Productos item) {
    _items.add(item);
  }

  List<Productos> getCartItems() {
    return _items;
  }

  void clearCart() {
    _items.clear();
  }
  //calcular el total a pagar por los productos
  double Total(){
    return _items.fold(0, (sum, item) => sum + item.price);
  }

}

//Clase de facturacion (extraer en pdf)
class Pdftransform {
  Future<String> generateInvoice(List<Productos> items) async {
    final pdf = pw.Document();
    double total = items.fold(0, (sum, item) => sum + item.price);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Factura', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...items.map(
                  (item) => pw.Text('${item.name}: \$${item.price}'),
            ),
            pw.Divider(),
            pw.Text('Total: \$${total.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/factura.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}


//Productos cargar desde un archivo json
class Productos {
  final String name;
  final int price;
  final String description;
  final String image;

  Productos({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      image: json['image'],
    );
  }
}

class ProductService {
  final Map<String, List<Productos>> _categories = {};

  Future<void> loadProducts() async {
    final String jsonString = await rootBundle.loadString('assets/datos/productos.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    jsonData.forEach((category, products) {
      _categories[category] = (products as List)
          .map((product) => Productos.fromJson(product))
          .toList();
    });
  }

  Map<String, List<Productos>> getCategories() {
    return _categories;
  }
}


