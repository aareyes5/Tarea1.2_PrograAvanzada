import 'package:flutter/material.dart';
import '../logica/logica_classes.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final ProductService _productService = ProductService();
  final Carrito _carrito = Carrito();

  bool checkboxValue = false;
  String? selectedOption;
  final List<String> options = ['Productos Populares', 'Menores a \$50'];

  @override
  void initState() {
    super.initState();
    _productService.loadProducts();
  }

  void _irAFactura() {
    Navigator.pushNamed(context, '/factura', arguments: _carrito.getCartItems());
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: checkboxValue,
                      onChanged: (value) {
                        setState(() {
                          checkboxValue = value!;
                        });
                      },
                    ),
                    Text(
                      'Mostrar solo productos en oferta',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  'Selecciona un filtro:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ...options.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _productService.getCategories().keys.length,
              itemBuilder: (context, index) {
                final category =
                _productService.getCategories().keys.elementAt(index);
                final products =
                    _productService.getCategories()[category] ?? [];

                return ExpansionTile(
                  title: Text(
                    category,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: products.map((product) {
                    if (checkboxValue && !product.isOnSale) return Container();
                    if (selectedOption == 'Productos Populares' && !product.isPopular) return Container();
                    if (selectedOption == 'Menores a \$50' && product.price > 50) return Container();

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
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _carrito.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${product.name} agregado al carrito'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE63946),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
