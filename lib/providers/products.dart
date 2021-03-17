import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  Map<String, String> _token;
  String _userId;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void update(String authToken, String userId) {
    if (authToken != null) {
      _token = {"auth": authToken};
    }
    if (userId != null) {
      _userId = userId;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final queryParams = filterByUser
        ? {..._token, "orderBy": "\"creatorId\"", "equalTo": "\"${_userId}\""}
        : _token;

    final url = Uri.https(
        "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
        "/products.json",
        queryParams);

    final urlFavorites = Uri.https(
        "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
        "/userFavorites/$_userId.json",
        _token);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) return;
      final favoriteResponse = await http.get(urlFavorites);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        final addedProd = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false);
        loadedProducts.add(addedProd);
        notifyListeners();
      });
      _items = loadedProducts;
    } catch (error) {
      print('Fetching Error $error');
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
        "/products.json",
        _token);
    final response = await http.post(url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "creatorId": _userId
        }));

    final id = json.decode(response.body)['name'];
    final newProduct = Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);

    _items.insert(0, newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex > -1) {
      final url = Uri.https(
          "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
          "/products/$id.json",
          _token);
      await http.patch(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));

      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
        "flutter-shop-app-6e97a-default-rtdb.europe-west1.firebasedatabase.app",
        "/products/$id.json",
        _token);

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    http.delete(url).then((resp) {
      if (resp.statusCode >= 400) {
        throw HttpException('Could Not Delete Product');
      }
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
  }
}
