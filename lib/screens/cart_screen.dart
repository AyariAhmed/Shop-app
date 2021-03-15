import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;


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
                  OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: (widget.cart.totalPriceAmount <= 0 || _isLoading) ? null : () async{
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        setState(() {
          _isLoading = true;
        });
       await Provider.of<Orders>(context,listen: false).addOrder(
            widget.cart.items.values.toList(), widget.cart.totalPriceAmount);
        widget.cart.clear();
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushNamed(OrdersScreen.routeName);
      },
      child: _isLoading ? Center(child: CircularProgressIndicator(),) : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
