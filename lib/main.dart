import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/helpers/custom_route.dart';
import 'package:shopify/screens/product_image_screen.dart';

import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/splash_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/product.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, Object> currentTheme = {
    'primary': Color(0xff0b1423),
    'accent': Color(0xffec981a),
    'canvas': Color(0xFFdedee1),
    'bodyText1': Color(0xFF332E38),
    'headline6': Color(0xFF332E38),
    'headline4': Color(0xFF332E38),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, oldProducts) => Products(
            auth.token,
            auth.userId,
            oldProducts == null ? [] : oldProducts.items,
          ),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Product(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, oldOrders) => Orders(
            auth.token,
            auth.userId,
            oldOrders == null ? [] : oldOrders.orders,
          ),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
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
                    fontWeight: FontWeight.bold,
                  ),
                  headline4: TextStyle(
                    color: currentTheme['headline4'],
                    fontSize: 16,
                  ),
                ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (context, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // '/': (ctx) => auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ProductImage.routeName: (ctx) => ProductImage(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          },
        ),
      ),
    );
  }
}
