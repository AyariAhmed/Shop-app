import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({@required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false});

  void _setFavValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }


  Future<void> toggleFavoriteStatus() async {
    final url = Uri.https(
        "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
        "/products/$id.json");
    final oldStatus = isFavorite;
    this.isFavorite = !this.isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(url, body: json.encode({
        "isFavorite": isFavorite
      }));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
