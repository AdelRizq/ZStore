import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductsItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                var confirmDeleting = showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are You Sure?'),
                    content: Text('Sure to remove thie product'),
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

                confirmDeleting.then(
                  (confirmation) {
                    if (confirmation)
                      Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                  },
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
