import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/utils/app_routes.dart';

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
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (context, auth, previous) => ProductList(
            auth.token ?? '',
            auth.userId ?? '',
            previous?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) => OrderList(
            auth.token ?? '',
            auth.userId ?? '',
            previous?.items ?? [],
          ),
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
            primarySwatch: Colors.purple,
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.purple,
              secondary: Colors.deepOrange,
            ),
          ),
          // home: ProductsOverviewPage(),
          routes: {
            AppRoutes.AUTH_OR_HOME: (context) => const AuthOrHomePage(),
            // AppRoutes.HOME: (context) => const ProductsOverviewPage(),
            AppRoutes.AUTH: (context) => const AuthPage(),
            AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
            AppRoutes.CART: (context) => CartPage(),
            AppRoutes.ORDERS: (context) => const OrdersPage(),
            AppRoutes.PRODUCTS: (context) => const ProductsPage(),
            AppRoutes.PRODUCT_FORM: (context) => const ProductFormPage(),
          }),
    );
  }
}
