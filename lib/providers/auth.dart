import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  Future<void> authentication(
      String email, String password, String segmentUrl) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyA_TOyeTnKA8H0w_njypXvyYxEAqNQrguU');
    final response = await http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    print(response.body);
  }

  Future<void> login(String email, String password) async {
    return authentication(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return authentication(email, password, 'signUp');
  }
}
