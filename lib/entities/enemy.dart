

import 'package:flutter/material.dart';

class Enemy {

  String name ;

  Enemy(this.name);

}

class TabPassModel extends ChangeNotifier {
  String _parameter = "";
  String get parameter => _parameter;

  void passParameter(String parameter) {
    _parameter = parameter;
    //print(_parameter);
    WidgetsBinding.instance!.addPostFrameCallback((_){
      notifyListeners();
    });

  }
}