import 'package:deliveryapp/src/pages/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../utils/my_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con = RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: -80,
                left: -100,
                child: _circle()
            ),
            Positioned(
                top: 70,
                left: 27,
                child: _textRegister()
            ),
            Positioned(
                top: 55,
                left: -5,
                child: _iconBack()
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 150),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _imageUser(),
                    SizedBox(height: 30),
                    _textFieldEmail(),
                    _textFieldName(),
                    _textFieldLastName(),
                    _textFieldPhone(),
                    _textFieldPassword(),
                    _textFieldConfirmPassword(),
                    _buttonRegister()
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _circle(){
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor
      ),
    );
  }

  Widget _iconBack(){
    return IconButton(
        onPressed: _con.back,
        icon: Icon(
            Icons.arrow_back_ios,
          color: Colors.white,
        )
    );
  }

  Widget _textRegister(){
    return const Text('REGISTRO',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'NimbusSans'
      ),
    );
  }

  Widget _imageUser(){
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile!) as ImageProvider
            : AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.emailController,
          decoration: InputDecoration(
            hintText: 'Correo electrónico',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor,
            ),
          )
      ),
    );
  }

  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.nameController,
          decoration: InputDecoration(
            hintText: 'Nombre',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            ),
          )
      ),
    );
  }

  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.lastNameController,
          decoration: InputDecoration(
            hintText: 'Apellido',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primaryColor,
            ),
          )
      ),
    );
  }

  Widget _textFieldPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: _con.phoneController,
          decoration: InputDecoration(
            hintText: 'Teléfono',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primaryColor,
            ),
          )
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
          controller: _con.passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColor,
            ),
          )
      ),
    );
  }

  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
          controller: _con.confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: MyColors.primaryColor,
            ),
          )
      ),
    );
  }

  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.register,
        child: Text('REGISTRARSE'),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }

}
