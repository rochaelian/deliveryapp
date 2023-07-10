import 'package:deliveryapp/src/pages/client/products/list/client_products_list_page.dart';
import 'package:deliveryapp/src/pages/client/update/client_update_page.dart';
import 'package:deliveryapp/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:deliveryapp/src/pages/login/login_page.dart';
import 'package:deliveryapp/src/pages/register/register_page.dart';
import 'package:deliveryapp/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:deliveryapp/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:deliveryapp/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:deliveryapp/src/pages/roles/roles_page.dart';
import 'package:deliveryapp/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login' : (BuildContext context) => LoginPage(),
        'register' : (BuildContext context) => RegisterPage(),
        'roles' : (BuildContext context) => RolesPage(),
        'client/update': (BuildContext context) => ClientUpdatePage(),
        'client/products/list': (BuildContext context) => ClientProductsListPage(),
        'restaurant/orders/list': (BuildContext context) => RestaurantOrdersListPage(),
        'restaurant/categories/create': (BuildContext context) => RestaurantCategoriesCreatePage(),
        'restaurant/products/create': (BuildContext context) => RestaurantProductsCreatePage(),
        'delivery/orders/list': (BuildContext context) => DeliveryOrdersListPage()
      },
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primaryColor: MyColors.primaryColor
      ),
    );
  }
}

