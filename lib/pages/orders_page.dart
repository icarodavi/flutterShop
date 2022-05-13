import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(context, listen: false)
        .loadOrders()
        .then((_) => setState(() => _isLoading = false));
  }

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);
    final items = orders.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      // drawer: MainDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.isEmpty
              ? const Center(child: Text('Sem pedidos'))
              : RefreshIndicator(
                  onRefresh: () => _refreshOrders(context),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: ((context, index) {
                      return OrderWidget(items[index]);
                    }),
                  ),
                ),
      drawer: const AppDrawer(),
    );
  }
}
