import 'package:flutter/material.dart';
import '../models/productos.dart';

/// Pantalla para la selección de productos del menú.
class ProductSelectionScreen extends StatefulWidget {
  final List<OrderItem> initialItems;
  const ProductSelectionScreen({super.key, required this.initialItems});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

/// Estado de la pantalla de selección de productos.
class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  final Map<String, int> _quantities = {};

/// Inicializa el estado con las cantidades de los ítems iniciales.
  @override
  void initState() {
    super.initState();
    for (var item in widget.initialItems) {
      _quantities[item.product.id] = item.quantity;
    }
  }

/// Actualiza la cantidad de un producto específico.
  void _updateQuantity(String id, int change) {
    setState(() {
      int current = _quantities[id] ?? 0;
      int next = current + change;
      if (next < 0) {            // No permitimos cantidades negativas
        _quantities.remove(id);  // Si baja de 0, se elimina
      } else {
        _quantities[id] = next;
      }
    });
  }

/// Confirma la selección y regresa a la pantalla anterior con los ítems seleccionados.
  void _confirm() {
    List<OrderItem> result = [];
    for (var product in menu) {
      if (_quantities.containsKey(product.id) && _quantities[product.id]! > 0) {
        result.add(OrderItem(product, _quantities[product.id]!));
      }
    }
    Navigator.pop(context, result);
  }

/// Construye la UI de la pantalla de selección de productos.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carta del Bar'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              // Definimos 6 columnas
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 300, // Tamaño fijo para cada tarjeta
              ),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final product = menu[index];
                final qty = _quantities[product.id] ?? 0;
                return Card(
                  elevation: 4, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Imagen del Producto
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.asset(
                            product.imageUrl,
                            height: 190, // Tamaño imagen
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => 
                              const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                          ),
                        ),
                        // Nombre y Precio
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12, // Texto más grande
                                  color: Colors.teal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${product.price.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontSize: 14, // Precio más grande
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Controles de Cantidad
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal.shade200),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.teal.shade50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.deepOrange, size: 16),
                                onPressed: () => _updateQuantity(product.id, -1),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(color: Colors.teal.shade200),
                                    right: BorderSide(color: Colors.teal.shade200),
                                  ),
                                ),
                                child: Text(
                                  '$qty',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green, size: 16),
                                onPressed: () => _updateQuantity(product.id, 1),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Botones de Confirmar/Cancelar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), // Cancelar sin devolver nada
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirm, // Confirma y devuelve la selección
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}