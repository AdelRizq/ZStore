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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.all(20),
        child: Icon(
          Icons.delete,
          // color: Theme.of(context).errorColor,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are You Sure?'),
            content: Text('Sure to remove this item ?'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text('$title'),
          subtitle: Text('Total: ${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
