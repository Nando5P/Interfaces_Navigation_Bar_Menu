import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/creacionDePedidos.dart';
import '../models/productos.dart';
import 'seleccionProductos.dart';
import 'order_summary_screen.dart';

class CreateOrderScreen extends StatelessWidget {
  final Order? initialOrder; 
  
  const CreateOrderScreen({super.key, this.initialOrder});

  void _goToProductSelection(BuildContext context, CreateOrderViewModel viewModel) async {
    final selectedItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSelectionScreen(initialItems: viewModel.selectedItems),
      ),
    );

    if (selectedItems != null && selectedItems is List<OrderItem>) {
      viewModel.updateSelectedItems(selectedItems);
    }
  }

  void _goToSummary(BuildContext context, Order order) {
    Navigator.pushNamed(
      context,
      OrderSummaryScreen.routeName,
      arguments: order,
    );
  }

  void _saveOrder(BuildContext context, CreateOrderViewModel viewModel) {
    if (!viewModel.canSave) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faltan datos (Mesa o Productos).')),
      );
      return;
    }
    Navigator.pop(context, viewModel.createFinalOrder());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = CreateOrderViewModel();
        viewModel.initializeOrder(initialOrder);
        return viewModel;
      },
      child: Consumer<CreateOrderViewModel>(
        builder: (context, viewModel, child) {
          final isEditing = viewModel.isEditing;
          
          return Scaffold(
            appBar: AppBar(title: Text(isEditing ? 'Editar Pedido' : 'Nuevo Pedido')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Campo para Nombre/Mesa
                  TextFormField(
                    initialValue: viewModel.tableOrName,
                    decoration: const InputDecoration(
                      labelText: 'Mesa o Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.table_restaurant),
                    ),
                    onChanged: viewModel.setTableOrName,
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón selección de productos
                  ElevatedButton.icon(
                    onPressed: () => _goToProductSelection(context, viewModel),
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Seleccionar Productos'),
                  ),
                  const SizedBox(height: 16),
                  
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Resumen:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      child: viewModel.selectedItems.isEmpty 
                        ? const Center(child: Text('Sin productos seleccionados'))
                        : ListView.builder(
                            itemCount: viewModel.selectedItems.length,
                            itemBuilder: (context, index) {
                              final item = viewModel.selectedItems[index];
                              return ListTile(
                                title: Text(item.product.name),
                                subtitle: Text('Cant: ${item.quantity}'),
                                trailing: Text('${item.totalPrice.toStringAsFixed(2)} €'),
                              );
                            },
                          ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Total: ${viewModel.totalAccumulated.toStringAsFixed(2)} €',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón ver resumen
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _goToSummary(context, viewModel.createFinalOrder()),
                          child: const Text('Ver Resumen Final'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Botones Cancelar / Guardar
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: viewModel.canSave 
                            ? () => _saveOrder(context, viewModel) : null, 
                          child: Text(isEditing ? 'Actualizar Pedido' : 'Guardar Pedido'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}