import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx,listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
/*    final productsData = Provider.of<Products>(context);*/

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage your products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx,snapshot)=> snapshot.connectionState == ConnectionState.waiting ?
          Center(child: CircularProgressIndicator(),):
        RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder:(ctx,Products productsData,_) =>Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final product = productsData.items[index];
                  return Column(
                    children: [
                      UserProductItem(
                        title: product.title,
                        imageUrl: product.imageUrl,
                        id: product.id,
                        deleteHandler: productsData.deleteProduct,
                      ),
                      Divider(
                        thickness: 0.9,
                      )
                    ],
                  );
                },
                itemCount: productsData.items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
