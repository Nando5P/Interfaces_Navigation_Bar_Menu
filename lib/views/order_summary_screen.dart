import 'package:flutter/material.dart';
import '../models/productos.dart';

/// Pantalla que muestra el resumen final de un pedido realizado en el bar.
/// 
/// Presenta el nombre de la mesa/cliente, la lista detallada de productos 
/// seleccionados con sus cantidades y el importe total a pagar.
class OrderSummaryScreen extends StatelessWidget {
  static const routeName = '/resumen';

  const OrderSummaryScreen({super.key});

  /// Muestra un Snackbar de agradecimiento al finalizar el proceso.
  void _finalizarProceso(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pedido procesado con éxito. ¡Buen servicio!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    // Volvemos al inicio tras mostrar el feedback
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Recuperar argumentos de la ruta
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen Final')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido para: ${order.tableOrName}', 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      child: Text('${item.quantity}', style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(item.product.name),
                    trailing: Text('${item.totalPrice.toStringAsFixed(2)} €'),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total a pagar: ${order.totalPrice.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Volver a la edición del pedido',
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Corregir'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Tooltip(
                    message: 'Confirmar y cerrar el pedido actual',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      onPressed: () => _finalizarProceso(context),
                      child: const Text('Finalizar'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}