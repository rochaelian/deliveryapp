import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/my_colors.dart';
import 'client_address_map_controller.dart';


class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({Key? key}) : super(key: key);

  @override
  State<ClientAddressMapPage> createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {

  final ClientAddressMapController _con = ClientAddressMapController();

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
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text('Ubica tu dirección en el mapa'),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          Container(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: _cardAddress(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonAccept(),
          )
        ],
      ),
    );
  }

  Widget _googleMaps(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position){
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  Widget _iconMyLocation(){
    return Image.asset(
      'assets/img/my_location.png',
      width: 65,
      height: 65,
    );
  }

  Widget _cardAddress(){
    return Container(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
              _con.addressName ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(
        onPressed: _con.selectRefPoint,
        child: Text(
            'SELECCIONAR ESTE PUNTO'
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ), backgroundColor: MyColors.primaryColor
        ),
      ),
    );
  }

  void refresh(){
    setState((){});
  }
}

class AlwaysDisableFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
