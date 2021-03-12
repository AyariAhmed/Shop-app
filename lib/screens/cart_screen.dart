import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/route';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart!'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalPriceAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context,listen: false).addOrder(
                          cart.items.values.toList(), cart.totalPriceAmount);
                      cart.clear();
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    },
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (ctx, index) {
              final cartItem = cart.items.values.toList()[index];
              return ci.CartItem(
                  id: cartItem.id,
                  prodId: cart.items.keys.toList()[index],
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  title: cartItem.title);
            },
          ))
        ],
      ),
    );
  }
}