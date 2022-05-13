import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';

import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.put(
        Uri.parse(
            '${Constants.USER_FAVORITES_URL}/$userId/$id.json?auth=$token'),
        body: jsonEncode(isFavorite));
    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(
        msg: 'Não foi possível realizar a ação.',
        statusCode: response.statusCode,
      );
    }
  }
}
