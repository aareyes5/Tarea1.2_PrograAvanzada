//Archivo donde se acumularan las clases que se usara la logica en varios haspectos de la aplicacion
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw;
import 'dart:convert';
import 'package:flutter/services.dart';


//Clase que se encarga de la autenticacion de los usuarios
class Usuario {
  final String username;
  final String password;

  Usuario({required this.username, required this.password});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      password: json['password'],
    );
  }
}

class AutenticacionLogin {
  final List<Usuario> _usuarios = [];

  Future<void> cargarUsuarios() async {
    try {
      // Usamos rootBundle para cargar el archivo desde assets
      final String jsonString = await rootBundle.loadString('assets/datos/usuarios.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);

      _usuarios.clear();
      _usuarios.addAll(jsonData.map((user) => Usuario.fromJson(user)).toList());
    } catch (e) {
      print('Error cargando usuarios: $e');
    }
  }

  bool login(String username, String password) {
    for (final usuario in _usuarios) {
      if (usuario.username == username && usuario.password == password) {
        return true;
      }
    }
    return false;
  }
}

//Clase que se encarga del carrito de compra
class Carrito {
  final List<String> _items = [];

  void addToCart(String item) {
    _items.add(item);
  }

  List<String> getCartItems() {
    return _items;
  }

  void clearCart() {
    _items.clear();
  }
}

//Clase de facturacion (extraer en pdf)
/* class Pdftransform {
     Future<String> generateInvoice(List<String> items) async {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: items.map((item) => pw.Text(item)).toList(),
          ),
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/invoice.pdf");
      await file.writeAsBytes(await pdf.save());
      return file.path;
    }
  }
*/
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


