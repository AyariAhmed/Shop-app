import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
        "/orders.json");
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "price": cp.price,
                      "quantity": cp.quantity
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: timeStamp));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
