import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../utils/shared_pref.dart';

class RolesController{

  BuildContext? context;
  Function? refresh;

  User? user;
  SharedPref sharedPref = SharedPref();

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    // OBTENER EL USUARIO DE SESION
    user = User.fromJson(await sharedPref.read('user'));
    refresh();
  }

  void goToPage(String route){
    Navigator.pushNamedAndRemoveUntil(context!, route, (route) => false);
  }
}