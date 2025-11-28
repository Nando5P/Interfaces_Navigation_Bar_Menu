import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/homeViewModel.dart';
import '../models/productos.dart';
import 'crearPedidoView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  void _createNewOrEditOrder({Order? orderToEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrderScreen(initialOrder: orderToEdit),
      ),
    );

    if (result != null && result is Order && mounted) {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      if (orderToEdit != null) {
        viewModel.updateOrder(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido modificado correctamente.')),
        );
      } else {
        viewModel.addOrder(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar App: Pedidos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.orders.isEmpty) {
            return const Center(child: Text('No hay pedidos activos.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: viewModel.orders.length,
            itemBuilder: (context, index) {
              final order = viewModel.orders[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: ExpansionTile(
                  shape: Border.all(color: Colors.transparent), 
                  collapsedShape: Border.all(color: Colors.transparent),
                  title: Text(
                    order.tableOrName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${order.totalProducts} productos'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón de Edición
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        tooltip: 'Editar pedido',
                        onPressed: () => _createNewOrEditOrder(orderToEdit: order),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${order.totalPrice.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.teal
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Botón de Eliminación
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Finalizar/Eliminar pedido',
                        onPressed: () {
                          Provider.of<HomeViewModel>(context, listen: false).removeOrder(order);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pedido finalizado y eliminado'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      const Icon(Icons.expand_more, color: Colors.grey),
                    ],
                  ),
                  children: order.items.map((item) {
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(fontSize: 12, color: Colors.teal),
                        ),
                      ),
                      title: Text(item.product.name),
                      trailing: Text('${item.totalPrice.toStringAsFixed(2)} €'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewOrEditOrder(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Pedido'),
        backgroundColor: const Color.fromARGB(255, 2, 104, 219),
        foregroundColor: Colors.white,
      ),
    );
  }
}