import 'dart:convert';
import 'dart:io';

import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/response_api.dart';
import '../../../models/user.dart';
import '../../../provider/users_provider.dart';
import '../../../utils/my_snackbar.dart';

class ClientUpdateController{

  BuildContext? context;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  File? imageFile;
  User user = User();
  bool isEnable = true;
  late Function refresh;
  late PickedFile pickedFile;
  late ProgressDialog _progressDialog;
  SharedPref _sharedPref = SharedPref();
  UsersProvider usersProvider = UsersProvider();

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    usersProvider.init(context, sessionUser: user);
    nameController.text = user.name!;
    lastNameController.text = user.lastname!;
    phoneController.text = user.phone!;
    refresh();
  }

  void update() async{
    String name = nameController.text;
    String lastname = lastNameController.text;
    String phone = phoneController.text.trim();

    if(name.isEmpty || lastname.isEmpty || phone.isEmpty){
      MySnackbar.show(context!, 'Debes ingresar todos los campos');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento');
    isEnable = false;

    User userUpdate = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        image: user.image
    );

    Stream? stream = await usersProvider.update(userUpdate, imageFile);
    stream?.listen((res) async {

      _progressDialog.close();
      ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message!);
      print('RESPUESTA: ${responseApi.toJson()}');

      if(responseApi.success!){

        user = await usersProvider.getById(user.id!);
        _sharedPref.save('user', user.toJson());
        print('USUARIO: ${user.toJson()}');
        Navigator.pushNamedAndRemoveUntil(context!, 'client/products/list', (route) => false);

      }else{
        isEnable = true;
      }
    });
  }

  Future? selectImage(ImageSource imageSourse) async{
    pickedFile = (await ImagePicker().getImage(source: imageSourse))!;
    if(pickedFile != null){
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context!);
    refresh();
  }


  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera);
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


  void back(){
    Navigator.pop(context!);
  }

}