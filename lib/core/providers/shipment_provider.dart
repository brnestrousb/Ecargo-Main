import 'package:flutter/material.dart';

class ShipmentProvider extends ChangeNotifier {
  int? _id;
  String? _resiNumber;

  int? get id => _id;
  String? get resiNumber => _resiNumber;

  void setShipmentData({required int id, required String resiNumber}) {
    _id = id;
    _resiNumber = resiNumber;
    notifyListeners();
  }

  void clearShipmentData() {
    _id = null;
    _resiNumber = null;
    notifyListeners();
  }
}
