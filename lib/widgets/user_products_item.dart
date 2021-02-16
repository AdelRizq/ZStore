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
    final scaffold = Scaffold.of(context);
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
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                var confirmDeleting = showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'Are You Sure?',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    content: Text(
                      'Sure to remove thie product',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(
                          'Yes',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(
                          'No',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                );

                await confirmDeleting.then(
                  (confirmation) async {
                    if (confirmation)
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(id);
                      } catch (_) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Deleting failed!, please try again'),
                          ),
                        );
                      }
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
