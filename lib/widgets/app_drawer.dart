import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shopify'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
        ],
      ),
    );
  }
}
