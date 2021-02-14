import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders].reversed.toList();
  }

  Future<void> getAndSetOrders() async {
    final url =
        'https://shopify-1b172-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final List<OrderItem> _loadedOrders = [];

    final response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data == null) return;

    data.forEach((orderId, order) {
      _loadedOrders.add(
        OrderItem(
          id: orderId,
          date: DateTime.parse(order['date']),
          total: order['total'],
          products: (order['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = _loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(double total, List<CartItem> products) async {
    final url =
        'https://shopify-1b172-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'total': total,
          'products': products,
          'date': DateTime.now(),
        }, toEncodable: datetimeSerializer),
      );

      _orders.add(
        OrderItem(
          id: json.decode(response.body)['name'],
          total: total,
          products: products,
          date: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  dynamic datetimeSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    } else if (object is CartItem) {
      return object.toJson();
    }
    return object;
  }
}
