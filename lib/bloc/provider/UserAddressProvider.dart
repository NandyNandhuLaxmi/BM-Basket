import 'package:flutter/cupertino.dart';
import 'package:bmbasket/bloc/model/Address.dart';

class UserAddressProvider extends ChangeNotifier{

  int _key;

  int get key => _key;
  Changekey(int value) {
    _key = value;
    notifyListeners();
  }
}
