import 'package:flutter/material.dart';
import 'dart:math';
import '../models/productos.dart';

/// Gestiona el estado temporal de un pedido mientras se está creando o editando.
class CreateOrderViewModel extends ChangeNotifier {
  String _tableOrName = '';
  List<OrderItem> _selectedItems = [];
  String? _originalId; // ID si estamos editando un pedido existente
  
  // NUEVO: Almacena la fecha original del pedido si estamos en modo edición
  DateTime? _originalDate; 
  
  // Exponemos el menú global para que la vista pueda acceder a él fácilmente
  final List<Product> menuItems = menu; 

  String get tableOrName => _tableOrName;
  List<OrderItem> get selectedItems => _selectedItems;
  bool get isEditing => _originalId != null;

  // Validación: Debe tener nombre/mesa y al menos un producto seleccionado
  bool get canSave => _tableOrName.trim().isNotEmpty && _selectedItems.isNotEmpty;

  // Total acumulado del pedido en curso
  double get totalAccumulated => _selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // CORREGIDO: Inicializa el ViewModel con un pedido existente para edición
  void initializeOrder(Order? initialOrder) {
    if (initialOrder != null) {
      _originalId = initialOrder.id;
      _tableOrName = initialOrder.tableOrName;
      _selectedItems = List.from(initialOrder.items); // Copia profunda de la lista
      _originalDate = initialOrder.date; // <-- Corregido: Guardamos la fecha original
    }
  }

  void setTableOrName(String value) {
    _tableOrName = value;
    notifyListeners();
  }

  // Actualiza la lista completa de ítems seleccionados desde la pantalla de selección
  void updateSelectedItems(List<OrderItem> newItems) {
    // Solo guardamos ítems con cantidad mayor a 0
    _selectedItems = newItems.where((item) => item.quantity > 0).toList();
    notifyListeners();
  }

  // CORREGIDO: Genera el objeto final Order
  Order createFinalOrder() {
    return Order(
      // Usamos el ID original si estamos editando
      id: _originalId ?? Random().nextInt(100000).toString(), 
      tableOrName: _tableOrName,
      items: _selectedItems,
      // Corregido: Usamos la fecha original guardada (_originalDate) si estamos editando
      date: isEditing ? _originalDate! : DateTime.now(), 
    );
  }
}