import 'package:flutter/material.dart';

class ProviderInfo with ChangeNotifier {
  double _number = 1.0;

  String _city = "Altamira";

  get city {
    return _city;
  }

  set city(String texto) {
    this._city = texto;
    notifyListeners();
  }

  get number {
    return _number;
  }

  set number(double number) {
    this._number = number;
    notifyListeners();
  }
}
