import 'package:deliveryapp/src/models/product.dart';
import 'package:deliveryapp/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:deliveryapp/src/utils/my_colors.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientProductsDetailPage extends StatefulWidget {

  final Product product;

  const ClientProductsDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ClientProductsDetailPage> createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {

  final ClientProductsDetailController _con = ClientProductsDetailController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _imageSlideShow(),
          _textName(),
          _textDescription(),
          Spacer(),
          _addOrRemoveItem(),
          _standardDelivery(),
          _buttonShoppingBag()
        ],
      ),
    );
  }

  Widget _imageSlideShow(){
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          initialPage: 0,
          indicatorColor: MyColors.primaryColor,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value){
            print('Page changed: $value');
          },
          autoPlayInterval: 30000,
          children: [
            FadeInImage(
              image: _con.product?.image1 != null
                  ? NetworkImage(_con.product!.image1!)
                  : AssetImage('assets/img/no-image.png') as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.product?.image2 != null
                  ? NetworkImage(_con.product!.image2!)
                  : AssetImage('assets/img/no-image.png') as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.product?.image3 != null
                  ? NetworkImage(_con.product!.image3!)
                  : AssetImage('assets/img/no-image.png') as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ],
        ),
        Positioned(
          left: 5,
          top: 10,
          child: IconButton(
            onPressed: _con.close,
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
            )
          ),
        )
      ],
    );
  }

  Widget _textName(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Text(
        _con.product?.name ?? '',
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _con.product?.description ?? '',
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey
        ),
      ),
    );
  }

  Widget _addOrRemoveItem(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.grey,
                size: 30,
              )
          ),
          Text(
            '${_con.counter}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            ),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
                size: 30,
              )
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              'c${_con.productPrice ?? 0}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _standardDelivery(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/img/delivery.png',
            height: 17,
          ),
          Text(
            'Envío estandar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonShoppingBag(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 40),
      child: ElevatedButton(
        onPressed: _con.addToBag,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'AGREGAR A LA BOLSA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 6),
                height: 30,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh(){
    setState(() {
    });
  }
}
