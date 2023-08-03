import 'package:deliveryapp/src/models/address.dart';
import 'package:deliveryapp/src/utils/my_colors.dart';
import 'package:deliveryapp/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'client_address_list_controller.dart';


class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key? key}) : super(key: key);

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {

  final ClientAddressListController _con = ClientAddressListController();

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
        title: Text('Direcciones'),
        actions: [
          _iconAdd()
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
              child: _textSelectAddress()
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
              child: _listAddress()
          )
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _iconAdd(){
    return IconButton(
        onPressed: _con.goToNewAddress,
        icon: Icon(Icons.add, color: Colors.white,)
    );
  }

  Widget _buttonNewAddress(){
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.goToNewAddress,
        child: Text(
            'Nueva dirección'
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue
        ),
      ),
    );
  }

  Widget _textSelectAddress(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Elige donde recibir tu orden',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _noAddress(){
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 30),
            child: NoDataWidget(text: 'No tienes ninguna dirección, agrega una nueva.')
        ),
        _buttonNewAddress()
      ],
    );
  }

  Widget _listAddress(){
    return FutureBuilder(
        future: _con.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.isNotEmpty){
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index){
                    return _radioSelectorAddress(snapshot.data![index], index);
                  }
              );
            }
            else{
              return _noAddress();
            }
          }else{
            return _noAddress();
          }
        }
    );
  }

  Widget _radioSelectorAddress(Address address, int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _con.radioValue,
                onChanged: _con.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address?.address ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    address?.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }

  Widget _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: (){},
        child: Text(
          'ACEPTAR'
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
