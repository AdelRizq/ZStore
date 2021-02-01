import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.total}'),
            subtitle:
                Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            SingleChildScrollView(
              child: Container(
                height: min(widget.order.products.length * 30.0 + 10, 100),
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order.products[i].title,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        '${widget.order.products[i].quantity} x \$${widget.order.products[i].price}',
                        // style:
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
