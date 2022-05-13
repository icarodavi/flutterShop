import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _baseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDilIVDffWPaGy9rOL_3E9UFi3vtHXtBXU';

  Future<void> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    print(jsonDecode(response.body));
  }
}