/// Modelo de datos para representar pedidos en el bar.
final List<Product> menu = [
  // NOTA: Las rutas de imagen deben coincidir con la carpeta 'assets/images' de tu proyecto.
  Product('m1', 'Estrella Galicia (33cl)', 2.50, 'assets/images/product_1.png'),
  Product('m2', 'Tapa Tortilla', 3.50, 'assets/images/product_2.png'),
  Product('m3', 'Tostada de Jamón', 5.30, 'assets/images/product_3.png'),
  Product('m4', 'Café', 1.20, 'assets/images/product_4.png'),
  Product('m5', 'Nachos con queso', 3.00, 'assets/images/product_5.png'),
  Product('m6', 'Tarta de Queso', 4.50, 'assets/images/product_6.png'),
  Product('m7', 'Coca-Cola', 2.30, 'assets/images/product_7.png'),
  Product('m8', 'Fanta de Naranja', 2.30, 'assets/images/product_8.png'),
  Product('m9', 'Bocadillo de Calamares', 6.80, 'assets/images/product_9.png'),
];

/// Representa un producto en la carta del bar.
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // Nuevo campo para la ruta de la imagen
  
  const Product(this.id, this.name, this.price, this.imageUrl);
}

/// Representa un ítem dentro de un pedido (Producto + Cantidad).
class OrderItem {
  final Product product;
  int quantity;
  
  OrderItem(this.product, this.quantity);

  // Cálculo: precio x cantidad
  double get totalPrice => product.price * quantity;
}

/// Representa un pedido completo.
class Order {
  final String id;
  final String tableOrName;
  final List<OrderItem> items;
  final DateTime date;

  Order({
    required this.id,
    required this.tableOrName,
    required this.items,
    required this.date,
  });

  // Cálculo del total de productos (suma de cantidades)
  int get totalProducts => items.fold(0, (sum, item) => sum + item.quantity);
  // Cálculo del precio total del pedido
  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);
}
// "La interfaz del sabor"
// "Pixel y pinta"
// "Bar 404"
// "UI/UX Bar"