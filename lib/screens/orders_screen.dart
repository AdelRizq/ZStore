import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getAndSetOrders(),
        builder: (ctx, snapshotState) {
          if (snapshotState.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshotState.error == null) {
              return Consumer<Orders>(
                builder: (ctx, data, child) => ListView.builder(
                  itemCount: data.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(data.orders[i]),
                ),
              );
            } else {
              return Center(child: Text('An error occured!'));
            }
          }
        },
      ),
    );
  }
}
