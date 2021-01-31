import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details_screen.dart';
import './screens/prodcuts_overview_screen.dart';

import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Map<String, Object> currentTheme = {
    'primary': Colors.red,
    'accent': Colors.redAccent,
    'canvas': Color.fromRGBO(253, 231, 181, 1),
    'bodyText1': Color.fromRGBO(26, 192, 198, 1),
    'headline6': Color.fromRGBO(26, 192, 198, 1),
    'headline4': Color.fromRGBO(26, 192, 198, 1),
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: currentTheme['primary'],
          accentColor: currentTheme['accent'],
          canvasColor: currentTheme['canvas'],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: currentTheme['bodyText1'],
                ),
                headline6: TextStyle(
                  color: currentTheme['headline6'],
                ),
                headline4: TextStyle(
                  color: currentTheme['headline4'],
                ),
              ),
        ),
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
