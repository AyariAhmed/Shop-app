import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context,listen: false);

    return Consumer<Product>(
      builder: (ctx, Product product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token,authData.userId);
              },
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
              icon: Icon(cart.prodInCart(product.id)
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined),
              onPressed: () {
                cart.addItem(
                    productId: product.id,
                    price: product.price,
                    title: product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added Item to Cart!'),
                  duration: Duration(seconds: 8),
                  action: SnackBarAction(label: 'Undo',onPressed: (){
                    cart.removeSingleItem(product.id);
                  },),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
          ),
        ),
      ),
    );
  }
}
