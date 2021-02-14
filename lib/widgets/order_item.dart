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
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.order.products.length * 20.0 + 150, 200)
          : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.total}'),
              subtitle: Text(
                  DateFormat('dd MM yyyy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            SingleChildScrollView(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 450),
                height: _isExpanded
                    ? min(widget.order.products.length * 20.0 + 10, 200)
                    : 0,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order.products[i].title,
                        style: Theme.of(context).textTheme.headline6,
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
      ),
    );
  }
}
