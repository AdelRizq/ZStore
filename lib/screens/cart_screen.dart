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
            margin: const EdgeInsets.all(15),
            child: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Chip(
                      label: Text('\$${cart.total.toStringAsFixed(2)}'),
                    ),
                    const Spacer(),
                    OrderFlatButton(cart),
                  ],
                ),
              );
            }),
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

class OrderFlatButton extends StatefulWidget {
  final cart;

  OrderFlatButton(this.cart);
  @override
  _OrderFlatButtonState createState() => _OrderFlatButtonState();
}

class _OrderFlatButtonState extends State<OrderFlatButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton(
            child: Text(
              'ORDER',
              style: Theme.of(context).textTheme.headline5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: (widget.cart.total == 0 || _isLoading)
                ? null
                : () async {
                    try {
                      setState(() => _isLoading = true);
                      await Provider.of<Orders>(context, listen: false)
                          .addOrder(
                        widget.cart.total,
                        widget.cart.items.values.toList(),
                      );
                      setState(() => _isLoading = false);
                      widget.cart.clear();
                    } catch (error) {
                      Scaffold.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text('Oops, please try again'),
                        ),
                      );
                    }
                  },
          );
  }
}
