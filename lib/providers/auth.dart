import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

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
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token" : _token,
        "userId" : _userId,
        "expiryDate" : _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLoging() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;

}

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, '/v1/accounts:signInWithPassword');
  }

  Future<void> logout() async{
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    /*prefs.remove('userData');*/
    prefs.clear();
  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry),logout);
  }

}
