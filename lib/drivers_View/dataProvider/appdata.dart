import 'package:drivers_app/drivers_View/datamodels/directionDetails.dart';
import 'package:drivers_app/drivers_View/datamodels/ride_details.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/drivers_View/datamodels/address.dart';


class AppData extends ChangeNotifier{

  Address driverAddress;
  RideDetails rideDetails;
  DirectionDetails directionDetails;


  void updateAddress(Address pickUp){

    driverAddress = pickUp;
    notifyListeners();

  }
  
  void updateRideDetails(RideDetails tripDetails){

      rideDetails = tripDetails;
      notifyListeners();

  }

  void updateDirectionDetails(details){
    directionDetails = details;
    notifyListeners();
  }
}