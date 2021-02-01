import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => OrderItem(orders[i]),
      ),
    );
  }
}
