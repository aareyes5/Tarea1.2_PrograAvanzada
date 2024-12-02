import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final ProductService _productService = ProductService();
  final Carrito _carrito = Carrito();

  @override
  void initState() {
    super.initState();
    _productService.loadProducts();
  }

  void _irAFactura() {
    Navigator.pushNamed(context, '/factura', arguments: _carrito.getCartItems());
  }

  void _logout() {
    // Redirigir al login
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Bloquear el botón de retroceso
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tienda de Zapatos'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: _irAFactura,
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: FutureBuilder(
          future: _productService.loadProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final categories = _productService.getCategories();

            return ListView.builder(
              itemCount: categories.keys.length,
              itemBuilder: (context, index) {
                final category = categories.keys.elementAt(index);
                final products = categories[category] ?? [];

                return ExpansionTile(
                  title: Text(
                    category,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: products.map((product) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      elevation: 3,
                      child: ListTile(
                        leading: Image.asset(
                          'assets/imagenes/${product.image}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.description),
                            SizedBox(height: 5),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _carrito.addToCart(product.name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} agregado al carrito'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('Agregar'),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
