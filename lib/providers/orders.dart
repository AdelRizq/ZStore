import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({
    @required this.id,
    @required this.total,
    @required this.products,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(double total, List<CartItem> products) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        total: total,
        products: products,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
