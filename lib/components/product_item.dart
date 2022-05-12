import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(product.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PRODUCT_FORM,
                    arguments: product,
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Excluir produto?'),
                        // content: const Text(''),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Sim'),
                          ),
                        ],
                      );
                    },
                  ).then((value) async {
                    if (value!) {
                      try {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).removeProduct(product);
                      } catch (err) {
                        msg.showSnackBar(
                          SnackBar(
                            content: Text(
                              'ERRO: ${err.toString()}',
                            ),
                          ),
                        );
                        print(err.toString());
                      }
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                )),
          ],
        ),
      ),
    );
  }
}
