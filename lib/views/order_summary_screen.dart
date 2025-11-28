import 'package:flutter/material.dart';
import '../models/productos.dart';

class OrderSummaryScreen extends StatelessWidget {
  static const routeName = '/resumen';

  const OrderSummaryScreen({super.key});

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
            Text('Pedido para: ${order.tableOrName}', 
                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    leading: Text('${item.quantity}x'),
                    title: Text(item.product.name),
                    trailing: Text('${item.totalPrice.toStringAsFixed(2)} €'),
                  );
                },
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total a pagar: ${order.totalPrice.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}