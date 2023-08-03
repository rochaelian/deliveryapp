import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {

  String text;

  NoDataWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset('assets/img/no_items.png'),
          Text(text)
        ],
      ),
    );
  }
}
