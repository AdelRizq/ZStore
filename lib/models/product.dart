import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  final double price;

  final bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.price,
    this.isFavorite = false,
  });
}
