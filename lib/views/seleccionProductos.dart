import 'package:flutter/material.dart';
import '../models/productos.dart';

class ProductSelectionScreen extends StatefulWidget {
  final List<OrderItem> initialItems;
  const ProductSelectionScreen({super.key, required this.initialItems});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  // Mapa local para editar cantidades: Map<ProductId, Quantity>
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    // Inicializamos con lo que ya venía seleccionado
    for (var item in widget.initialItems) {
      _quantities[item.product.id] = item.quantity;
    }
  }

  void _updateQuantity(String id, int change) {
    setState(() {
      int current = _quantities[id] ?? 0;
      int next = current + change;
      if (next < 0) { // No permitimos cantidades negativas
        _quantities.remove(id); // Si baja de 0, se elimina
      } else {
        _quantities[id] = next;
      }
    });
  }

  void _confirm() {
    // Convertimos el mapa de vuelta a lista de OrderItem
    List<OrderItem> result = [];
    for (var product in menu) {
      if (_quantities.containsKey(product.id) && _quantities[product.id]! > 0) {
        result.add(OrderItem(product, _quantities[product.id]!));
      }
    }
    // Devolvemos la lista de items seleccionados a la pantalla de creación
    Navigator.pop(context, result);
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
              // Definimos 6 columnas
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                // Mantenemos 0.6 para altura corta
                childAspectRatio: 0.6, 
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
                        // Imagen del Producto (flex: 2 para que ocupe menos)
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: Image.asset(
                              product.imageUrl, // Se usa la propiedad del modelo
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => 
                                const Center(child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey)),
                            ),
                          ),
                        ),
                        
                        // Nombre y Precio (AHORA SIN EXPANDED, ocupa solo el espacio necesario)
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
                                  fontSize: 10,
                                  color: Colors.teal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${product.price.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontSize: 12,
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