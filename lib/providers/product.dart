import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  final double price;

  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.price,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
