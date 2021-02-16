import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken, userId;

  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  List<Product> get items {
    return [..._items]; // just a copy
  }

  List<Product> get favorites {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product getById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> getAndSetProducts([filterProducts = false]) async {
    String filterCommand =
        filterProducts ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      String url =
          'https://zstore-4a53e-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterCommand';
      final response = await http.get(url);
      final products = json.decode(response.body) as Map<String, dynamic>;
      List<Product> fetchedProducts = [];

      if (products == null) return;

      url =
          'https://zstore-4a53e-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoritesResponse = await http.get(url);
      final favoritesData =
          json.decode(favoritesResponse.body) as Map<String, dynamic>;

      products.forEach((productId, product) {
        fetchedProducts.add(
          Product(
            id: productId,
            creatorId: userId,
            title: product['title'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            description: product['description'],
            isFavorite: favoritesData == null
                ? false
                : favoritesData[productId] ?? false,
          ),
        );
      });
      _items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://zstore-4a53e-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'creatorId': userId,
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
        }),
      );

      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          creatorId: userId,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      final url =
          'https://zstore-4a53e-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'creatorId': userId,
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'description': product.description,
        }),
      );

      _items[index] = product;
      notifyListeners();
    } else {
      print('Updating Product: index not found');
    }
  }

  Future<void> deleteProduct(String id) async {
    String filterCommand = '&orderBy="creatorId"&equalTo="$userId"';
    final productIndex = _items.indexWhere((product) => product.id == id);
    var tempProduct = _items[productIndex];
    final url =
        'https://zstore-4a53e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken$filterCommand';

    // optimistic updating (remove then check if it's removed or not)
    _items.removeWhere((item) => item.id == id);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(productIndex, tempProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    tempProduct = null;
  }
}
