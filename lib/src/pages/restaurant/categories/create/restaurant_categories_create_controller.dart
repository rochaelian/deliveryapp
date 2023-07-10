import 'package:deliveryapp/src/models/response_api.dart';
import 'package:deliveryapp/src/provider/categories_provider.dart';

import 'package:deliveryapp/src/utils/my_snackbar.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';


import 'package:flutter/material.dart';

import '../../../../models/category.dart';
import '../../../../models/user.dart';

class RestaurantCategoriesCreateController{

  BuildContext? context;
  late Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CategoriesProvider _categoriesProvider = CategoriesProvider();
  SharedPref sharedPref = SharedPref();
  User? user;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user!);
  }

  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if(name.isEmpty || description.isEmpty){
      MySnackbar.show(context!, 'Debe ingresar todos los campos');
      return;
    }


    Category category = Category(
        name: name,
        description: description
    );

    ResponseApi? responseApi = await _categoriesProvider.create(category);

    MySnackbar.show(context!, responseApi!.message!);

    if(responseApi!.success!){
      nameController.text = '';
      descriptionController.text = '';
    }

  }

}