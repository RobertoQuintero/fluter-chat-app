import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  bool _estaEscribiendo = false;

  bool get estaEscribiendo => this._estaEscribiendo;
  set estaEscribiendo(bool value) {
    _estaEscribiendo = value;
    notifyListeners();
  }
}
