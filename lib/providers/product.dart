import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String creatorId;
  final String description;

  final double price;

  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.creatorId,
    @required this.description,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String authToken, String userId) async {
    var url =
        'https://zstore-4a53e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.put(
      url,
      body: json.encode(isFavorite),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not toggle favoritism');
    }
  }
}
