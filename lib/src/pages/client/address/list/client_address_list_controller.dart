import 'package:flutter/material.dart';

import '../../../../models/address.dart';
import '../../../../models/user.dart';
import '../../../../provider/address_provider.dart';
import '../../../../utils/shared_pref.dart';

class ClientAddressListController{

  late BuildContext context;
  Function? refresh;

  final AddressProvider _addressProvider = AddressProvider();
  final SharedPref _sharedPref = SharedPref();
  List<Address> address = [];
  int radioValue = 0;
  bool? isCreated;
  User? user;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user!);

    refresh();
  }

  void handleRadioValueChange(int? value) async {
    radioValue = value!;
    _sharedPref.save('address', address[value]);

    refresh!();
    print('Valor seleccionado: $radioValue');
  }

  Future<List<Address>> getAddress() async{
    address = await _addressProvider.getByUser(user!.id!);

    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);

    if(index != -1){
      radioValue = index;
    }
    print('SE GUARDÓ LA DIRECCIÓN: ${a.toJson()}');

    return address;
  }

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, 'client/address/create');

    if(result != null){
      if(result == true){
        refresh!();
      }
    }
  }

}