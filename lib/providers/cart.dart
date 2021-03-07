import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:uuid/uuid.dart';


class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  bool prodInCart(productId){
    return _items.containsKey(productId);
  }

  int get itemCount{
    return _items.length;
  }

  double get totalPriceAmount{
    double total = 0.0;
    _items.forEach((prodId , cartItem) {
      total+= cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
      {@required String productId,
      @required double price,
      @required String title}) {
    if (prodInCart(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: Uuid().v4(), title: title, quantity: 1, price: price));
    }
    notifyListeners();
  }

  void removeItem(String prodId){
    _items.remove(prodId);
    notifyListeners();
  }
  void clear(){
    _items = {};
    notifyListeners();
  }

}
