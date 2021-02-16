import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_image_screen.dart';

import '../providers/cart.dart';
import '../providers/auth.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static String routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).getById(productId);
    // Product pproduct = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: _AppBar(product: product, auth: auth),
      body: Builder(
        builder: (context) => CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
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
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .1,
                    ),
                    child: Text(
                      product.title,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .fontSize,
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
                                    const Text('CART'),
                                    const SizedBox(width: 15),
                                    const Icon(Icons.shopping_cart_outlined),
                                  ],
                                ),
                                onPressed: () {
                                  cart.addItem(
                                      product.id, product.title, product.price);
                                  Scaffold.of(context).hideCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Added item to the cart'),
                                      duration: const Duration(seconds: 2),
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

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const _AppBar({
    Key key,
    @required this.product,
    @required this.auth,
  }) : super(key: key);

  final Product product;
  final Auth auth;

  @override
  __AppBarState createState() => __AppBarState();
}

class __AppBarState extends State<_AppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        FlatButton(
          height: 60,
          child: Icon(
            widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            widget.product
                .toggleFavorite(widget.auth.token, widget.auth.userId);
            setState(() {});
          },
        ),
      ],
    );
  }
}
