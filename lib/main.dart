import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_details_screen.dart';
import './screens/prodcuts_overview_screen.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, Object> currentTheme = {
    'primartSwatch': Colors.red,
    'primary': Colors.red,
    'accent': Colors.redAccent,
    'canvas': Color.fromRGBO(253, 231, 181, 1),
    'bodyText1': Color.fromRGBO(26, 192, 198, 1),
    'headline6': Color.fromRGBO(26, 192, 198, 1),
    'headline4': Color.fromRGBO(26, 192, 198, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: currentTheme['primartSwatch'],
          primaryColor: currentTheme['primary'],
          accentColor: currentTheme['accent'],
          canvasColor: currentTheme['canvas'],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: currentTheme['bodyText1'],
                ),
                headline6: TextStyle(
                  color: currentTheme['headline6'],
                  fontSize: 20,
                ),
                headline4: TextStyle(
                  color: currentTheme['headline4'],
                  fontSize: 16,
                ),
              ),
        ),
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
        },
      ),
    );
  }
}
