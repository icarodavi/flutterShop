import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping Application',
          theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch: Colors.green,
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.green,
              secondary: Colors.deepOrange,
            ),
          ),
          home: ProductsOverviewPage(),
          routes: {
            AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
            AppRoutes.CART: (context) => const CartPage(),
          }),
    );
  }
}
