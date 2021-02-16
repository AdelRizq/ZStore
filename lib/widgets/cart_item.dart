import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;

class CartItem extends StatelessWidget {
  final String id, title, productId;

  final double price;

  final int quantity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.productId,
  });

  Widget _alertDialog(BuildContext ctx) {
    return AlertDialog(
      title: const Text('Are You Sure?'),
      content: const Text('Sure to remove this item ?'),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Yes'),
        ),
        FlatButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('No'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.all(20),
        child: const Icon(
          Icons.delete,
          // color: Theme.of(context).errorColor,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => _alertDialog(ctx),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).accentColor,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
              ),
            ),
          ),
          title: Text('$title'),
          subtitle: Text('Total: ${(price * quantity).toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonTheme(
                minWidth: 20.0,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .addItem(productId, title, price);
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 20,
                child: IconButton(
                  icon: const Icon(Icons.remove),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeSingleItem(productId);
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .05,
              ),
              Text('$quantity x'),
            ],
          ),
        ),
      ),
    );
  }
}
