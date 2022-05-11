import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product_list.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of<ProductList>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Gerenciar produtos')),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (context, index) => Column(
              children: [
                ProductItem(products.items[index]),
                const Divider(),
              ],
            ),
          )),
    );
  }
}
