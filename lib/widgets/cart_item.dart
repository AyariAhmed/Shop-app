import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {

  final String id;
  final double price;
  final int quantity;
  final String title;


  CartItem(
      {@required this.id, @required this.price, @required this.quantity, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: ListTile(
          leading: CircleAvatar(child: FittedBox(child: Padding(padding: EdgeInsets.all(2), child: Text('\$$price'))),),
          title: Text(title),
          subtitle: Text('Total: \$${(price*quantity)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
