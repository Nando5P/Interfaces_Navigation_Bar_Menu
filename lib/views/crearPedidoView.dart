import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/creacionDePedidos.dart';
import '../models/productos.dart';
import 'seleccionProductos.dart';
import 'order_summary_screen.dart';

/// Pantalla para crear o editar un pedido de la aplicación del Bar.
/// 
/// Permite al usuario asignar una mesa, seleccionar productos y ver un resumen
/// antes de confirmar el guardado.
class CreateOrderScreen extends StatelessWidget {
  final Order? initialOrder; 
  
  const CreateOrderScreen({super.key, this.initialOrder});

  /// Navega a la pantalla de selección de productos.
  /// 
  /// Muestra un [SnackBar] informativo al regresar si se han actualizado los ítems.
  void _goToProductSelection(BuildContext context, CreateOrderViewModel viewModel) async {
    final selectedItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSelectionScreen(initialItems: viewModel.selectedItems),
      ),
    );

    if (selectedItems != null && selectedItems is List<OrderItem>) {
      viewModel.updateSelectedItems(selectedItems);
      // Snackbar de feedback al volver de la selección
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lista de productos actualizada'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// Navega a la pantalla de resumen detallado del pedido.
  void _goToSummary(BuildContext context, Order order) {
    Navigator.pushNamed(
      context,
      OrderSummaryScreen.routeName,
      arguments: order,
    );
  }

  /// Valida y guarda el pedido.
  /// 
  /// Muestra un error mediante [SnackBar] si el pedido no es válido.
  void _saveOrder(BuildContext context, CreateOrderViewModel viewModel) {
    if (!viewModel.canSave) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Debes indicar una mesa y añadir al menos un producto.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Si todo es correcto, cerramos devolviendo el pedido
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
                  // Validación visual en el campo de texto
                  TextFormField(
                    initialValue: viewModel.tableOrName,
                    decoration: InputDecoration(
                      labelText: 'Mesa o Nombre',
                      hintText: 'Ej: Mesa 5 o Juan Pérez',
                      errorText: viewModel.tableOrName.isEmpty ? 'Este campo es obligatorio' : null,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.table_restaurant),
                    ),
                    onChanged: viewModel.setTableOrName,
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón selección de productos con Tooltip
                  Tooltip(
                    message: 'Abrir el catálogo de productos',
                    child: ElevatedButton.icon(
                      onPressed: () => _goToProductSelection(context, viewModel),
                      icon: const Icon(Icons.list_alt),
                      label: const Text('Seleccionar Productos'),
                    ),
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
                  
                  // Botón ver resumen con Tooltip
                  Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: 'Revisar todos los detalles antes de guardar',
                          child: OutlinedButton(
                            onPressed: () => _goToSummary(context, viewModel.createFinalOrder()),
                            child: const Text('Ver Resumen Final'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Botones Cancelar / Guardar con Tooltips
                  Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: 'Salir sin guardar los cambios',
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Tooltip(
                          message: isEditing ? 'Actualizar los datos del pedido' : 'Registrar el pedido en el sistema',
                          child: ElevatedButton(
                            onPressed: viewModel.canSave 
                              ? () => _saveOrder(context, viewModel) : null, 
                            child: Text(isEditing ? 'Actualizar Pedido' : 'Guardar Pedido'),
                          ),
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