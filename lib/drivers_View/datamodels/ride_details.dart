import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails{


  String rideId;
  String pickup;

  LatLng pickLatLng;



  String destination;
  LatLng desLatLng;


  RideDetails({this.rideId,this.pickup, this.pickLatLng,this.destination, this.desLatLng});


}