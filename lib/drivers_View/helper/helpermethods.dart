import 'package:drivers_app/drivers_View/datamodels/directionDetails.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drivers_app/drivers_View/datamodels/address.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:drivers_app/drivers_View/dataProvider/appdata.dart';
import 'requesthelper.dart';


class HelperMethod{

    static Future<dynamic> findCoordinateAddress(Position position, context) async{

      String placeAddress = 'failed';
      String url = "https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude}, ${position.latitude}.json?access_token=${mapBoxKey}";
      var data = await RequestHelper.getRequest(url);
      // print("Data Below____________________");

      if(data != 'failed'){
         placeAddress = data['features'][0]['place_name'];
         //print(placeAddress);
         Address pickUpAddress = new Address(placeName: placeAddress, latitude: position.latitude, longitude: position.longitude);
         Provider.of<AppData>(context, listen: false).updateAddress(pickUpAddress);
         // print(Provider.of<AppData>(context).pickUpAddress.placeName);

      }

       return placeAddress;

    }

    static Future<DirectionDetails> getDirectionsDetails(LatLng startingPosition, LatLng endPosition) async{

      String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startingPosition.latitude},${startingPosition.longitude}&destination=${endPosition.latitude}, ${endPosition.longitude} & mode=driving&key=${mapKey}";
      var response = await RequestHelper.getRequest(url);

      if (response == 'failed') {
        return null;
      }

      if (response['status'] == 'OK') {
        DirectionDetails directionDetails = DirectionDetails();
        directionDetails.durationText = response['routes'][0]["legs"][0]["duration"]["text"];
        directionDetails.distanceText = response['routes'][0]["legs"][0]["distance"]["text"];
        directionDetails.durationValue = response['routes'][0]["legs"][0]["duration"]["value"];
        directionDetails.distanceValue = response['routes'][0]["legs"][0]["distance"]["value"];
        directionDetails.encodedPoints = response['routes'][0]["overview_polyline"]["points"];
        return directionDetails;
      }

    }
    
    static void disableHomeTabLocationUpdates(){
      
      homeTapPositionStream.pause();
      Geofire.removeLocation(currentUser.uid);
    }

    static void enableHomeTabLocationUpdates(){


      homeTapPositionStream.resume();
      Geofire.setLocation(currentUser.uid, currentPosition.latitude, currentPosition.longitude);

    }


}