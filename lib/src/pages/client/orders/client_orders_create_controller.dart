import 'package:deliveryapp/src/models/product.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ClientOrdersCreateController {

  late BuildContext context;
  Function? refresh;
  Product? product;

  SharedPref _sharedPref = SharedPref();
  List<Product> selectedProducts = [];
  double? productPrice;
  int counter = 1;
  double total = 0;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product?.price!;

    //_sharedPref.remove('order');
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    getTotal();
    selectedProducts.forEach((p) {
      print('Producto seleccionado: ${p.toJson()}');
    });

    refresh();
  }

  void getTotal(){
    total = 0;
    for (var product in selectedProducts) {
      total = total + (product.quantity! * product.price!);
    }
    refresh!();
  }


  void addItem(Product product){
    int index = selectedProducts.indexWhere((p) => p.id == product?.id);
    selectedProducts[index].quantity = selectedProducts[index].quantity! + 1;
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void removeItem(Product product){

    if(product.quantity! > 1){
      int index = selectedProducts.indexWhere((p) => p.id == product?.id);
      selectedProducts[index].quantity = selectedProducts[index].quantity! - 1;
      _sharedPref.save('order', selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product){
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void goToAddress(){
    Navigator.pushNamed(context, 'client/address/list');
  }

}