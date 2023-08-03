import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../utils/my_colors.dart';
import 'client_address_create_controller.dart';


class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({Key? key}) : super(key: key);

  @override
  State<ClientAddressCreatePage> createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {

  final ClientAddressCreateController _con = ClientAddressCreateController();

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
        title: Text('Nueva dirección'),
      ),
      body: Column(
        children: [
          _textCompleteData(),
          _textFieldAddress(),
          _textFieldNeighborhood(),
          _textFieldRefPoint()
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _textCompleteData(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Completa los siguientes datos',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textFieldAddress(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.addressController,
        decoration: InputDecoration(
            labelText: 'Dirección',
            labelStyle: const TextStyle(
                color: Colors.grey
            ),
            suffixIcon: Icon(
              Icons.location_on,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }

  Widget _textFieldNeighborhood(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.neighborhoodController,
        decoration: InputDecoration(
          labelText: 'Barrio',
          labelStyle: const TextStyle(
              color: Colors.grey
          ),
          suffixIcon: Icon(
            Icons.location_city,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldRefPoint(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.refPointController,
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwaysDisableFocusNode(),
        decoration: InputDecoration(
          labelText: 'Punto de referencia',
          labelStyle: const TextStyle(
              color: Colors.grey
          ),
          suffixIcon: Icon(
            Icons.map,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.createAddress,
        child: Text(
            'CREAR DIRECCIÓN'
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
