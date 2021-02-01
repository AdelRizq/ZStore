import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static final routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.total}'),
                  ),
                  FlatButton(
                    child: Text(
                      'ORDER',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .addOrder(cart.total, cart.items.values.toList());
                      cart.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (_, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
