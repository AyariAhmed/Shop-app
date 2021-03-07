import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                switch (selectedValue) {
                  case FilterOptions.Favorites:
                    productsContainer.showFavoritesOnly();
                    break;
                  case FilterOptions.All:
                    productsContainer.showAll();
                    break;
                }
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterOptions.All,
                    ),
                  ])
        ],
      ),
      body: ProductGrid(),
    );
  }
}
