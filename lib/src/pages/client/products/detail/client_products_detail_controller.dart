import 'package:deliveryapp/src/models/product.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ClientProductsDetailController{

  late BuildContext context;
  Function? refresh;
  Product? product;

  SharedPref _sharedPref = SharedPref();
  List<Product> selectedProducts = [];
  int counter = 1;
  double? productPrice;

  Future? init(BuildContext context, Function refresh, Product product) async{
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product?.price!;

   // _sharedPref.remove('order');
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;

    selectedProducts.forEach((p) {
      print('Producto seleccionado: ${p.toJson()}');
    });


    refresh();
  }

  void addItem(){
    counter++;
    productPrice = product!.price! * counter;
    product?.quantity = counter;
    refresh!();
  }

  void removeItem(){
    if(counter > 1){
      counter = counter -1;
      productPrice = product!.price! * counter;
      product?.quantity = counter;
      refresh!();
    }
  }

  void addToBag(){

    int index = selectedProducts.indexWhere((p) => p.id == product?.id);

    if(index == -1){
      product?.quantity ??= 1;

      selectedProducts.add(product!);
    }else{
      selectedProducts[index].quantity = counter;
    }

    _sharedPref.save('order', selectedProducts);
    Fluttertoast.showToast(msg: 'Producto agregado');
  }

  void close(){
    Navigator.pop(context);
  }

}