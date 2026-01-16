import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/homeViewModel.dart';
import '../models/productos.dart';
import 'crearPedidoView.dart';

/// Pantalla principal que gestiona y visualiza el listado de pedidos activos del bar.
/// 
/// Permite al usuario ver un resumen de todas las mesas, editar pedidos existentes
/// o eliminarlos una vez finalizados.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Estado de la pantalla principal que maneja la lógica de navegación y feedback.
class _HomeScreenState extends State<HomeScreen> {
  
  /// Inicia el flujo para crear un nuevo pedido o modificar uno existente.
  /// 
  /// Al regresar de la pantalla de creación, si hay datos válidos, se actualiza
  /// el [HomeViewModel] y se muestra un [SnackBar] informativo.
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
          const SnackBar(
            content: Text('Pedido modificado correctamente.'),
            backgroundColor: Colors.blueAccent,
          ),
        );
      } else {
        viewModel.addOrder(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nuevo pedido añadido a la lista.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Muestra un diálogo de confirmación antes de eliminar un pedido.
  /// 
  /// Esta validación evita que el usuario borre una comanda por accidente.
  void _confirmarEliminacion(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Finalizar pedido?'),
          content: Text('Se eliminará el pedido de "${order.tableOrName}" de la lista.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Provider.of<HomeViewModel>(context, listen: false).removeOrder(order);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pedido finalizado y eliminado'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('ELIMINAR', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
            return const Center(
              child: Text('No hay pedidos activos.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
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
                  subtitle: Text('${order.totalProducts} productos seleccionados'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Tooltip(
                        message: 'Editar los productos o el nombre de este pedido',
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _createNewOrEditOrder(orderToEdit: order),
                        ),
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
                      Tooltip(
                        message: 'Marcar como finalizado y borrar de la lista',
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarEliminacion(context, order),
                        ),
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
      floatingActionButton: Tooltip(
        message: 'Añadir una nueva comanda',
        child: FloatingActionButton.extended(
          onPressed: () => _createNewOrEditOrder(),
          icon: const Icon(Icons.add),
          label: const Text('Nuevo Pedido'),
          backgroundColor: const Color.fromARGB(255, 2, 104, 219),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}