import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items]; // just a copy
  }

  List<Product> get favorites {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product getById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> getAndSetProducts() async {
    const url =
        'https://shopify-1b172-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final products = json.decode(response.body) as Map<String, dynamic>;
      List<Product> fetchedProducts = [];
      products.forEach((productId, product) {
        fetchedProducts.add(
          Product(
              id: productId,
              title: product['title'],
              price: product['price'],
              imageUrl: product['imageUrl'],
              description: product['description'],
              isFavorite: product['isFavorite']),
        );
      });
      _items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://shopify-1b172-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'isFavorite': product.isFavorite,
        }),
      );

      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      final url =
          'https://shopify-1b172-default-rtdb.firebaseio.com/products/${product.id}.json';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'isFavorite': product.isFavorite,
          }));

      _items[index] = product;
      notifyListeners();
    } else {
      print('Updating Product: index not found');
    }
  }

  Future<void> deleteProduct(String id) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    var tempProduct = _items[productIndex];
    final url =
        'https://shopify-1b172-default-rtdb.firebaseio.com/products/$id';

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
