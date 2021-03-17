import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final Map<String, String> _keyParam = {
    'key': 'AIzaSyDuG - RA277C431Lk2uDLaDMNfAYtq4ThgU'
  };

  bool get isAuth {
    return token != null;
  }

  String get userId{
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        Uri.https('identitytoolkit.googleapis.com', urlSegment, _keyParam);
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signInWithPassword');
  }

  void logout(){
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }
}
