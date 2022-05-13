import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';

class CartPage extends StatelessWidget {
  final NumberFormat formatter =
      NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);
  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
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
                    CartButton(cart: cart, msg: msg),
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

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
    required this.msg,
  }) : super(key: key);

  final Cart cart;
  final ScaffoldMessengerState msg;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: () async {
              if (widget.cart.itemsCount == 0) {
                null;
              } else {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<OrderList>(
                    context,
                    listen: false,
                  ).addOrder(widget.cart);
                  widget.cart.clear();
                } catch (err) {
                  widget.msg.showSnackBar(const SnackBar(
                      content: Text('Erro ao salvar seu pedido!')));
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
              // Navigator.of(context).pushNamed(AppRoutes.ORDERS);
            },
            child: const Text('Comprar'),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
  }
}
