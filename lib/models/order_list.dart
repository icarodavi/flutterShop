import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((e) => {
                  'id': e.id,
                  'productId': e.productId,
                  'name': e.name,
                  'quantity': e.quantity,
                  'price': e.price,
                })
            .toList(),
      }),
    );
    if (response.statusCode >= 400) {
      throw HttpException(
        msg: 'Erro ao salvar o seu pedido.',
        statusCode: response.statusCode,
      );
    }
    final id = jsonDecode(response.body)['name'];
    _items.insert(
        0,
        Order(
          id: id,
          total: cart.totalAmount,
          date: date,
          products: cart.items.values.toList(),
        ));
    notifyListeners();
  }

  Future<void> loadOrders() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      _items.add(Order(
        id: key,
        total: value['total'],
        products: (value['products'] as List<dynamic>)
            .map((e) => CartItem(
                  id: e['id'],
                  productId: e['productId'],
                  name: e['name'],
                  quantity: e['quantity'],
                  price: e['price'],
                ))
            .toList(),
        date: DateTime.parse(value['date']),
      ));
    });
    notifyListeners();
  }
}
