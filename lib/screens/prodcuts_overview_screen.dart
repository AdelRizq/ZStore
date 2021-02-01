import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';

import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';

import '../providers/cart.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static final routeName = '/products-overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopify'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (FiltersOptions value) {
              setState(() {
                if (value == FiltersOptions.Favorites) {
                  showFavorites = true;
                } else if (value == FiltersOptions.All) {
                  showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOptions.Favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(showFavorites),
    );
  }
}
