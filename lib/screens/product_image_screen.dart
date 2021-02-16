import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductImage extends StatelessWidget {
  static const routeName = '/product-image';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).getById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Hero(
        tag: product.id,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3,
          child: Center(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }
}
