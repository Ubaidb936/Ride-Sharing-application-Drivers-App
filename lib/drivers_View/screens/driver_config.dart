import 'dart:async';
import 'dart:io';
import 'package:drivers_app/constants.dart';
import 'package:drivers_app/drivers_View/dataProvider/appdata.dart';
import 'package:drivers_app/drivers_View/datamodels/directionDetails.dart';
import 'package:drivers_app/drivers_View/datamodels/driver.dart';
import 'package:drivers_app/drivers_View/datamodels/ride_details.dart';
import 'package:drivers_app/drivers_View/helper//helpermethods.dart';
import 'package:drivers_app/drivers_View/widgets/CustomButton.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';



class DriverConfig extends StatefulWidget {


  final RideDetails tripDetails;

  DriverConfig({this.tripDetails});
  static String id = 'driverConfig';

  @override
  _DriverConfigState createState() => _DriverConfigState();
}

class _DriverConfigState extends State<DriverConfig> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController rideMapController;
  double rideMapPadding = 0;




  BitmapDescriptor nearbyIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};


  void acceptTrip(DriverDetails driverDetails){

    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rideRequest/${widget.tripDetails.rideId}');
    rideRef.child('status').set('accepted');
    rideRef.child('driver_id').set(currentUser.uid);
    rideRef.child('driver_name').set(driverDetails.fullName);
    rideRef.child('driver_email').set(driverDetails.email);
    rideRef.child('driver_phoneNumber').set(driverDetails.phoneNumber);
    rideRef.child('driver_vehicleName').set(driverDetails.vehicleName);
    rideRef.child('driver_vehicleColor').set(driverDetails.vehicleColor);
    rideRef.child('driver_vehicleNumber').set(driverDetails.vehicleNumber);

    Map mapRef = {

      'lat': currentPosition.latitude,
      'lng': currentPosition.longitude,

    };

    rideRef.child('driver_LatLng').set(mapRef);

  }


  @override
  void initState() {
    // TODO: implement initState

    acceptTrip(driverDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: rideMapPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            polylines: _polylines,
            zoomControlsEnabled: true,
            markers: _Markers,
            circles: _Circles,
            onMapCreated: (GoogleMapController controller) async{
              _controller.complete(controller);
              rideMapController = controller;

              var driverLatLnt = LatLng(currentPosition.latitude, currentPosition.longitude);
              var desLatLng = widget.tripDetails.pickLatLng;


              await getDirection(driverLatLnt, desLatLng);

              setState(() {
                rideMapPadding = Platform.isIOS ? 270 : 280;
              });



            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('15min'),
                    Row(
                      children: [
                        Text(
                          'Ubaid ul majied',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.phone)
                      ],
                    ),

                    Container(
                      height: 100,
                      decoration:BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 30,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Row(
                              children: [
                                Image.asset('assets/images/pickicon.png'),
                                SizedBox(width: 5,),
                                Text('Agrikalan')
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset('assets/images/desticon.png'),
                                SizedBox(width: 5,),
                                Text('LalChowk, Srinagar')
                              ],
                            ),

                          ],

                        ),
                      ),

                    ),


                    CustomButton(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getDirection(pickLatLng, desLatLng) async {


    DirectionDetails thisDetails =
    await HelperMethod.getDirectionsDetails(pickLatLng, desLatLng);

    Provider.of<AppData>(context, listen: false).updateDirectionDetails(thisDetails);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =  polylinePoints.decodePolyline(thisDetails.encodedPoints);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('polyid'),
          color: Color.fromARGB(255, 95, 109, 237),
          points: polylineCoordinates,
          jointType: JointType.round,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if (pickLatLng.latitude > desLatLng.latitude &&
        pickLatLng.longitude > desLatLng.longitude) {
      bounds = LatLngBounds(southwest: desLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > desLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, desLatLng.longitude),
          northeast: LatLng(desLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > desLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(desLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, desLatLng.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickLatLng, northeast: desLatLng);
    }

    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: desLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
        circleId: CircleId('pickup'),
        strokeColor: Colors.green,
        strokeWidth: 3,
        radius: 20,
        center: pickLatLng,
        fillColor: Colors.green);

    Circle destinationCircle = Circle(
        circleId: CircleId('destination'),
        strokeColor: Colors.purple,
        strokeWidth: 3,
        radius: 20,
        center: desLatLng,
        fillColor: Colors.deepPurpleAccent);

    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });
  }



}


