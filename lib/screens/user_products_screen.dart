import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/edit_product_screen.dart';
import 'package:shopify/widgets/app_drawer.dart';

import '../widgets/user_products_item.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<Products>(
                        builder: (ctx, products, _) => ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (ctx, i) => Column(
                            children: [
                              UserProductsItem(
                                id: products.items[i].id,
                                title: products.items[i].title,
                                imageUrl: products.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
