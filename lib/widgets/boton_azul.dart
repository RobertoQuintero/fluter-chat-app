import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String title;
  final VoidCallback? callback;

  const BotonAzul({Key? key, required this.title, this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.blue, elevation: 2, shape: StadiumBorder()),
        onPressed: this.callback,
        child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: Text(this.title,
                style: TextStyle(color: Colors.white, fontSize: 17))));
  }
}
