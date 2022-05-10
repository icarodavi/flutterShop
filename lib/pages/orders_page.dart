import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);
    final items = orders.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      // drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: ((context, index) {
          return OrderWidget(items[index]);
        }),
      ),
      drawer: const AppDrawer(),
    );
  }
}
