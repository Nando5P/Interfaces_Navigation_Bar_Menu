import 'package:flutter/material.dart';
import 'dart:math';
import '../models/productos.dart';

class CreateOrderViewModel extends ChangeNotifier {
  String _tableOrName = '';
  List<OrderItem> _selectedItems = [];
  String? _originalId; // solo si editamos un pedido existente
  DateTime? _originalDate; 

  final List<Product> menuItems = menu; 

  String get tableOrName => _tableOrName;
  List<OrderItem> get selectedItems => _selectedItems;
  bool get isEditing => _originalId != null;

  bool get canSave => _tableOrName.trim().isNotEmpty && _selectedItems.isNotEmpty;

  double get totalAccumulated => _selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  void initializeOrder(Order? initialOrder) {
    if (initialOrder != null) {
      _originalId = initialOrder.id;
      _tableOrName = initialOrder.tableOrName;
      _selectedItems = List.from(initialOrder.items); 
      _originalDate = initialOrder.date; 
    }
  }

  void setTableOrName(String value) {
    _tableOrName = value;
    notifyListeners();
  }

  void updateSelectedItems(List<OrderItem> newItems) {
    // Solo guardamos ítems con cantidad mayor a 0
    _selectedItems = newItems.where((item) => item.quantity > 0).toList();
    notifyListeners();
  }

  Order createFinalOrder() {
    return Order(
      id: _originalId ?? Random().nextInt(100000).toString(), 
      tableOrName: _tableOrName,
      items: _selectedItems,
      date: isEditing ? _originalDate! : DateTime.now(), 
    );
  }
}