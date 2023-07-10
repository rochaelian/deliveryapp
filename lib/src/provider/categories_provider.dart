import 'dart:convert';

import 'package:deliveryapp/src/api/environment.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/response_api.dart';
import '../models/category.dart';
import '../models/user.dart';

class CategoriesProvider{
  String _url = Environment.API_DELIVERY;
  String _api = '/api/categories';
  BuildContext? context;
  User? sessionUser;

  Future? init(BuildContext context, User sessionUser){
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Category>> getAll() async{
    try{
      Uri url = Uri.http(_url, '$_api/getAll');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };
      final res = await http.get(url, headers: headers);
      if(res.statusCode == 401){
        Fluttertoast.showToast(msg: 'Sesión expirada.');
        new SharedPref().logout(context!, sessionUser!.id);
      }

      final data = json.decode(res.body);
      Category category = Category.fromJsonList(data);
      category.toList.forEach((element) {
        print(element.id);
        print(element.name);
        print(element.description);
      });
      return category.toList;

    }catch(e){
      print('Error $e');
      return [];
    }
  }

  Future<ResponseApi?> create(Category category) async{
    try{
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(category);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      if(res.statusCode == 401){
        Fluttertoast.showToast(msg: 'Sesión expirada.');
        new SharedPref().logout(context!, sessionUser!.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }catch(e){
      print('Error: $e');
      return null;
    }
  }
}