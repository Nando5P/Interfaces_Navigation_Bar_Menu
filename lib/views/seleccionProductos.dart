import 'package:flutter/material.dart';
import '../models/productos.dart';

/// Pantalla que despliega la carta del bar para que el usuario seleccione productos.
/// 
/// Gestiona un estado local de cantidades mediante un [Map] y permite 
/// sincronizar la selección con los datos previos del pedido.
class ProductSelectionScreen extends StatefulWidget {
  final List<OrderItem> initialItems;
  const ProductSelectionScreen({super.key, required this.initialItems});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

/// Estado que controla la lógica de incremento/decremento de productos.
class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  final Map<String, int> _quantities = {};

  /// Inicializa las cantidades basándose en los ítems que ya estaban en el pedido.
  @override
  void initState() {
    super.initState();
    for (var item in widget.initialItems) {
      _quantities[item.product.id] = item.quantity;
    }
  }

  /// Actualiza la cantidad de un producto. Si la cantidad llega a 0, se mantiene en el mapa
  /// para permitir volver a incrementarla fácilmente, pero no se incluirá al confirmar.
  void _updateQuantity(String id, int change) {
    setState(() {
      int current = _quantities[id] ?? 0;
      int next = current + change;
      if (next < 0) {
        _quantities[id] = 0; // Evitamos negativos
      } else {
        _quantities[id] = next;
      }
    });
  }

  /// Valida que haya al menos un producto seleccionado antes de cerrar.
  /// 
  /// Si la validación falla, muestra un [SnackBar] de error.
  void _confirm() {
    List<OrderItem> result = [];
    for (var product in menu) {
      if (_quantities.containsKey(product.id) && _quantities[product.id]! > 0) {
        result.add(OrderItem(product, _quantities[product.id]!));
      }
    }

    if (result.isEmpty) {
      // Validación: No permitir confirmar si no hay nada seleccionado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Selecciona al menos un producto para continuar.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      Navigator.pop(context, result);
    }
  }

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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 320, 
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
                        // Imagen con gestión de error
                        Image.asset(
                          product.imageUrl,
                          height: 190,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                        ),
                        // Información del producto
                        Column(
                          children: [
                            Text(product.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                            Text('${product.price.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 14, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Controles de cantidad con Tooltips
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
                              Tooltip(
                                message: 'Quitar unidad',
                                child: IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.deepOrange, size: 16),
                                  onPressed: () => _updateQuantity(product.id, -1),
                                ),
                              ),
                              Text('$qty', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
                              Tooltip(
                                message: 'Añadir unidad',
                                child: IconButton(
                                  icon: const Icon(Icons.add, color: Colors.green, size: 16),
                                  onPressed: () => _updateQuantity(product.id, 1),
                                ),
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
          // Botones de acción final
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Volver atrás sin guardar cambios',
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Tooltip(
                    message: 'Confirmar selección de productos',
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      child: const Text('Confirmar'),
                    ),
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