import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items;
  final String? _userId;
  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      items.where((element) => element.isFavorite).toList();
  final String? _token;

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    final favoriteResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData = favoriteResponse.body == 'null'
        ? {}
        : jsonDecode(favoriteResponse.body);

    data.forEach((key, value) {
      final isFavorite = favData[key] ?? false;
      _items.add(Product(
        id: key,
        name: value['name'],
        description: value['description'],
        price: value['price'],
        imageUrl: value['imageUrl'],
        isFavorite: isFavorite,
      ));
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
        Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }));
    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
          Uri.parse(
              '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();
      final response = await http.delete(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token '),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possível excluir o produto',
            statusCode: response.statusCode);
      }
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
