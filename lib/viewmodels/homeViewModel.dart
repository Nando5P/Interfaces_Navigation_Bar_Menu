import 'package:flutter/material.dart';
import '../models/productos.dart';

/// Gestiona el estado de la lista principal de pedidos.
class HomeViewModel extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  HomeViewModel() {
    _loadInitialOrders();
  }

  // Carga datos iniciales para cumplir con los requisitos
  void _loadInitialOrders() {
    _orders = [
      Order(
        id: 'o1',
        tableOrName: 'Mesa 1',
        items: [
          OrderItem(menu[0], 2), // 2 Cerveza
          OrderItem(menu[2], 1), // 1 Tostada
        ],
        date: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Order(
        id: 'o2',
        tableOrName: 'Nombre: Laura',
        items: [
          OrderItem(menu[3], 3), // 3 Cafés
          OrderItem(menu[5], 1), // 1 Tarta
        ],
        date: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners(); // Notifica a la UI para que se redibuje
  }

  // Método para eliminar un pedido (simular pago/entrega)
  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }

  // NUEVO MÉTODO: Actualiza un pedido existente
  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }
}