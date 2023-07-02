

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/response_api.dart';
import '../../models/user.dart';
import '../../provider/users_provider.dart';
import '../../utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController{

  BuildContext? context;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  late PickedFile pickedFile;
  File? imageFile;
  late Function refresh;

  Future? init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);
  }

  void register() async{
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastNameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmPasswordController.text.trim();

    if(email.isEmpty || name.isEmpty || lastname.isEmpty || phone.isEmpty || password.isEmpty || confirmpassword.isEmpty){
      MySnackbar.show(context!, 'Debes ingresar todos los campos');
      return;
    }

    if(confirmpassword != password){
      MySnackbar.show(context!, 'Las contraseñas no coinciden');
      return;
    }

    if(password.length < 6){
      MySnackbar.show(context!, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if(imageFile == null){
      MySnackbar.show(context!, 'Seleccione una imagen');
      return;
    }

    User user = User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        password: password
    );

    Stream? stream = await usersProvider.createWithImage(user, imageFile!);
    stream?.listen((res) async {
     // ResponseApi? responseApi = await usersProvider.create(user);

      ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi.toJson()}');

      MySnackbar.show(context!, responseApi.message!);


      if(responseApi.success!){
        Future.delayed(Duration(seconds: 3), (){
          Navigator.pushReplacementNamed(context!, 'login');
        });
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