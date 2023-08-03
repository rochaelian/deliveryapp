import 'package:deliveryapp/src/models/address.dart';
import 'package:deliveryapp/src/models/response_api.dart';
import 'package:deliveryapp/src/pages/client/address/map/client_address_map_page.dart';
import 'package:deliveryapp/src/provider/address_provider.dart';
import 'package:deliveryapp/src/utils/my_snackbar.dart';
import 'package:deliveryapp/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../models/user.dart';

class ClientAddressCreateController{

  late BuildContext context;
  Function? refresh;

  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController refPointController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  AddressProvider _addressProvider = AddressProvider();
  SharedPref _sharedPref = SharedPref();
  Map<String, dynamic>? refPoint;
  User? user;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProvider.init(context, user!);
    refresh();
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neigborhood = neighborhoodController.text;
    double lat = refPoint!['lat'] ?? 0;
    double lng = refPoint!['lng'] ?? 0;

    if(addressName.isEmpty || neigborhood.isEmpty || lat == 0 || lng == 0){
      MySnackbar.show(context, 'Debes completar todos los campos');
      return;
    }

    Address address = Address(
      address: addressName,
      neighborhood: neigborhood,
      lat: lat,
      lng: lng,
      idUser: user?.id
    );


    ResponseApi? responseApi = await _addressProvider.create(address);

    if(responseApi!.success!){

      address.id = responseApi.data;
      _sharedPref.save('address', address);

      Fluttertoast.showToast(msg: 'Dirección agregada.');
      Navigator.pop(context!, true);

    }else{
      MySnackbar.show(context!, responseApi!.message!);
    }

  }

  void openMap() async {
    refPoint = await showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ClientAddressMapPage()
    );

    if (refPoint != null){
      refPointController.text = refPoint!['address'];
      refresh!;
    }
  }
  
}