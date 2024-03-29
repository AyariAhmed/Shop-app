import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavo;

  ProductGrid(this.showFavo);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        showFavo ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) {
          Product product = loadedProducts[i];
          return ChangeNotifierProvider.value(
            value: product,
            child: ProductItem(),
          );
        });
  }
}
