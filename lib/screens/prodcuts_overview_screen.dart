import 'package:flutter/material.dart';

import '../widgets/product_item.dart';

import '../models/product.dart';

import '../temp_data.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static final routeName = '/products-overview';
  final List<Product> products = tempData.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopify'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ProductItem(products[i]),
        itemCount: products.length,
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
