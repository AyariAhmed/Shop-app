import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    /*final orderData = Provider.of<Orders>(context);*/ // With FutureBuild this cause and infinite Loop
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders!'),
          actions: [
            IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                })
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapshot.error != null) {
              // Error Handling code
              return Center(
                child: Text('An Error Occurred'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<Orders>(context, listen: false)
                      .fetchAndSetOrders();
                },
                child: Consumer<Orders>(
                  builder: (ctx, Orders orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, index) {
                        return OrderItem(orderData.orders[index]);
                      }),
                ),
              );
            }
          },
        ));
  }
}
