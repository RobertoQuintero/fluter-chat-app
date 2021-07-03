import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({Key? key, this.title = 'Messenger'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Image(image: AssetImage('assets/tag-logo.png')),
          SizedBox(height: 20),
          Text(this.title, style: TextStyle(fontSize: 30))
        ],
      ),
    );
  }
}
