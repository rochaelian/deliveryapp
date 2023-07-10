import 'dart:convert';
import 'dart:io';

import 'package:deliveryapp/src/models/response_api.dart';
import 'package:deliveryapp/src/provider/products_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:deliveryapp/src/utils/my_snackbar.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:deliveryapp/src/models/category.dart';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../provider/categories_provider.dart';


class RestaurantProductsCreateController{

  BuildContext? context;
  late Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  final ProductsProvider _productsProvider = ProductsProvider();
  SharedPref sharedPref = SharedPref();
  late ProgressDialog _progressDialog;
  List<Category>? categories = [];
  String? idCategory;
  User? user;

  // IMAGENES
  late PickedFile pickedFile;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _progressDialog = ProgressDialog(context: context);
    _categoriesProvider.init(context, user!);
    _productsProvider.init(context, user!);
    getCategories();
  }

  void getCategories() async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void createProduct() async {
    String name = nameController.text;
    String description = descriptionController.text;
    String priceString = priceController.text;
    double price = double.parse(priceString);

    if(name.isEmpty || description.isEmpty || price == 0.0){
      MySnackbar.show(context!, 'Debe ingresar todos los campos');
      return;
    }

    if(imageFile1 == null || imageFile2 == null || imageFile3 == null){
      MySnackbar.show(context!, 'Seleccione 3 imágenes');
      return;
    }

    if(idCategory == null){
      MySnackbar.show(context!, 'Seleccione la categoría del producto');
      return;
    }

    Product product = Product(
        name: name,
        description: description,
        price: price,
        idCategory: int.parse(idCategory!)
    );

    List<File> images = [];
    images.add(imageFile1!);
    images.add(imageFile2!);
    images.add(imageFile3!);

    _progressDialog.show(max: 100, msg: 'Espere un momento');
    Stream? stream = await _productsProvider.create(product, images);

    stream?.listen((res) {

      print('RECIBE RESPUESTA');

      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context!, responseApi.message!);

      if(responseApi.success!){
        resetValues();
      }

    });

    print('Formulario Producto: ${product.toJson()}');

  }

  void resetValues(){
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory = null;
    refresh();
  }

  Future? selectImage(ImageSource imageSourse, int numberFile) async{
    pickedFile = (await ImagePicker().getImage(source: imageSourse))!;

    if(pickedFile != null){
      if(numberFile == 1){
        imageFile1 = File(pickedFile.path);
      }else if(numberFile == 2){
        imageFile2 = File(pickedFile.path);
      }else if(numberFile == 3){
        imageFile3 = File(pickedFile.path);
      }
    }

    Navigator.pop(context!);
    refresh();
  }


  void showAlertDialog(int numberFile){
    Widget galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context!,
        builder: (BuildContext context){
          return alertDialog;
        }
    );
  }

}