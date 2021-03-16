import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final Map<String,String> _keyParam = {'key':'AIzaSyDuG - RA277C431Lk2uDLaDMNfAYtq4ThgU'};

  Future<void> signup(String email, String password) async {
    final url = Uri.https('identitytoolkit.googleapis.com',
        '/v1/accounts:signUp',_keyParam);
    final response = await http.post(url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    print(json.decode(response.body));
  }

  Future<void> signin(String email, String password) async {
    final url = Uri.https('identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithPassword',_keyParam);
    final response = await http.post(url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    print(json.decode(response.body));
  }
}
