import 'dart:convert';

import 'package:deliveryapp/src/api/environment.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/response_api.dart';
import '../models/address.dart';
import '../models/user.dart';

class AddressProvider{
  String _url = Environment.API_DELIVERY;
  String _api = '/api/address';
  BuildContext? context;
  User? sessionUser;

  Future? init(BuildContext context, User sessionUser){
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<ResponseApi?>? create(Address address) async{
    try{
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(address);
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

  Future<List<Address>> getByUser(String idUser) async{
    try{
      Uri url = Uri.http(_url, '$_api/findByUser/${idUser}');
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
      Address address = Address.fromJsonList(data);

      return address.toList;

    }catch(e){
      print('Error $e');
      return [];
    }
  }

}