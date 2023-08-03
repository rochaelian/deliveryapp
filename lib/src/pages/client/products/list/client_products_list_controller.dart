import 'package:deliveryapp/src/models/category.dart';
import 'package:deliveryapp/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:deliveryapp/src/provider/categories_provider.dart';
import 'package:deliveryapp/src/provider/products_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/shared_pref.dart';

class ClientProductsListController{

  BuildContext? context;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  CategoriesProvider _categoriesProvider = CategoriesProvider();
  ProductsProvider _producsProvider = ProductsProvider();
  List<Category>? categories = [];
  Function? refresh;
  User? user;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user!);
    _producsProvider.init(context, user!);
    getCategories();
    refresh();
  }

  Future<List<Product>> getProducts(String idCategory) async{
    return await _producsProvider.getByCategory(idCategory);
  }

  void getCategories() async{
    categories = await _categoriesProvider.getAll();
    refresh!();
  }

  void openBottomSheet(Product product){
    showMaterialModalBottomSheet(
      context: context!,
      builder: (context) => ClientProductsDetailPage(product: product)
    );
  }

  void logout(){
    _sharedPref.logout(context!, user!.id);
  }

  void openDrawer(){
    key.currentState!.openDrawer();
  }

  void goToUpdatePage(){
    Navigator.pushNamed(context!, 'client/update');
  }

  void gotoRoles(){
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }

  void goToOrderCreatePage(){
    Navigator.pushNamed(context!, 'client/orders/create');
  }
}