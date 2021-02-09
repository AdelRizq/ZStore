import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> toggleFavorite() async {
    final url =
        'https://shopify-1b172-default-rtdb.firebaseio.com/products/$id.json';

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.patch(
      url,
      body: json.encode({
        'isFavorite': isFavorite,
      }),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not toggle favoritism');
    }
  }
}
