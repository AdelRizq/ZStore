import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/product_image_screen.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductDetailsScreen extends StatelessWidget {
  static String routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).getById(productId);
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<Product>(
            builder: (ctx, product, _) => FlatButton(
              height: 60,
              child: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleFavorite(auth.token, auth.userId);
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        ProductImage.routeName,
                        arguments: product.id,
                      ),
                      child: Hero(
                        tag: product.id,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .1,
                    ),
                    child: Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          '${product.description}',
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.5),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  Divider(
                    thickness: 2,
                    endIndent: MediaQuery.of(context).size.width * 0.1,
                    indent: MediaQuery.of(context).size.width * 0.1,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Consumer<Cart>(
                              builder: (ctx, cart, _) => RaisedButton(
                                elevation: 0,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.1),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: Theme.of(context).accentColor),
                                ),
                                child: Row(
                                  children: [
                                    Text('CART'),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(Icons.shopping_cart_outlined),
                                  ],
                                ),
                                onPressed: () {
                                  cart.addItem(
                                      product.id, product.title, product.price);
                                  Scaffold.of(context).hideCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added item to the cart'),
                                      duration: Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          cart.removeSingleItem(product.id);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
