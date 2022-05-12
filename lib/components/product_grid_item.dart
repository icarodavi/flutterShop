import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_DETAIL,
                arguments: product,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              onPressed: () async {
                try {
                  await product.toggleFavorite();
                } catch (err) {
                  msg.showSnackBar(
                    SnackBar(
                      content: Text('ERRO! ${err.toString()}'),
                    ),
                  );
                }
              },
              icon: product.isFavorite
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.error,
                    )
                  : const Icon(Icons.favorite_border_outlined),
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto foi adicionado com sucesso'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              );
              cart.addItem(product);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }
}
