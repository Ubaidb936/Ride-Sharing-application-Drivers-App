import 'package:flutter/material.dart';
import 'package:drivers_app/drivers_View/datamodels/address.dart';


class AppData extends ChangeNotifier{

  Address pickUpAddress;
  void updateAddress(Address pickUp){

    pickUpAddress = pickUp;
    notifyListeners();

  }
}