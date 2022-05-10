import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/utils/app_routes.dart';

class CartPage extends StatelessWidget {
  final NumberFormat formatter =
      NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);
  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Carrinho de compras'),
        ),
        body: Column(children: [
          Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        formatter.format(cart.totalAmount),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Provider.of<OrderList>(
                          context,
                          listen: false,
                        ).addOrder(cart);
                        cart.clear();
                        // Navigator.of(context).pushNamed(AppRoutes.ORDERS);
                      },
                      child: const Text('Comprar'),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: ((context, index) => CartItemWidget(items[index])),
            ),
          )
        ]));
  }
}
