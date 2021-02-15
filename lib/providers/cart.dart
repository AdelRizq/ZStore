import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;

  double price;

  int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });

  void increaseQuantity() {
    this.quantity++;
  }

  CartItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        price = json['price'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'title': this.title,
        'price': this.price,
        'quantity': this.quantity,
      };
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get total {
    double total = 0;
    _items.forEach((_, product) {
      total += product.price * product.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (item) {
          item.increaseQuantity();
          return item;
        },
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity == 1) {
        _items.remove(productId);
      } else {
        _items.update(
          productId,
          (product) {
            product.quantity--;
            return product;
          },
        );
      }
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
