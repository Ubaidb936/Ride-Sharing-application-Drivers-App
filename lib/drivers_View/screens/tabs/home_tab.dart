import 'dart:async';
import 'package:drivers_app/drivers_View/widgets/dialog.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:drivers_app/drivers_View/widgets/bottom_sheet.dart';
import 'package:drivers_app/helpers/pushnotifications.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}





class _HomeTabState extends State<HomeTab> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAvailable = false;
  //double mapPadding = 0;
  // double height = Platform.isIOS ? 300 : 275;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
  Position currentPosition;

  DatabaseReference tripReference;
  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    //var pickUp = await HelperMethod.findCoordinateAddress(position, context);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void goOnline() {
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(
        currentUser.uid, currentPosition.latitude, currentPosition.longitude);

    tripReference = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentUser.uid}/newTrip');
    tripReference.set('waiting.....');
    tripReference.onValue.listen((event) { });
  }

  void goOffline(){

    Geofire.removeLocation(currentUser.uid);
    tripReference.onDisconnect();
    tripReference.remove();
    tripReference = null;


  }

  void locationUpdates() {
    StreamSubscription<Position> homeTapPositionStream;

    homeTapPositionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 4)
        .listen((Position position) {
      currentPosition = position;

      if(isAvailable){

        Geofire.setLocation(
            currentUser.uid, position.latitude, position.longitude);

      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    });
  }

  void getDriverUserInfo() async{

       //currentFirebaseUser = await FirebaseAuth.instance.currentUser;

       PushNotificationsService pushNotificationsService = PushNotificationsService();
       pushNotificationsService.initialize(context);
       pushNotificationsService.getToken();



  }



  void testing(){


    DatabaseReference newRideRef = FirebaseDatabase.instance.reference()
        .child('rideRequests/12345');


    Map userMap = {

      'pickUp': 'Magam, Budgam',
      'destination': 'Lalchowk, Srinagar',
    };

    DatabaseReference newTripRef = FirebaseDatabase.instance.reference()
        .child('drivers/${currentUser.uid}/newTrip');

    newTripRef.set('waiting....');


    newRideRef.set(userMap);



  }










  
  @override
  void initState() {
   testing();
   getDriverUserInfo();

    //getDriverUserInfo();
    super.initState();
  }
  @override
  void dispose() {
    mapController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            //padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              // setState(() {
              //   mapPadding = Platform.isIOS ? 270 : 280;
              // });
              setupPositionLocator();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: isAvailable? Colors.red: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: FlatButton(
                  child: !isAvailable? Text('Go online'): Text('Go offline'),
                  onPressed: () {
                    // scaffoldKey.currentState
                    //     .showBottomSheet((context) => Container(
                    //           height: 100,
                    //           child: Column(
                    //             children: [
                    //               !isAvailable? Text("Go Online"): Text("Go offline"),
                    //               SizedBox(
                    //                 height: 20,
                    //               ),
                    //               !isAvailable? Text("your are about to go online"): Text("you are about to go offline"),
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Container(
                    //                       decoration: BoxDecoration(
                    //                           color: Colors.blue, borderRadius: BorderRadius.circular(30)),
                    //                       child: FlatButton(
                    //                     onPressed: (){
                    //                       Navigator.pop(context);
                    //                     },
                    //                     child: Text("Go Back"),
                    //                     color: Colors.white,
                    //                   )),
                    //
                    //
                    //                   Container(
                    //                     decoration: BoxDecoration(
                    //                         color: Colors.greenAccent, borderRadius: BorderRadius.circular(30)),
                    //                     child: FlatButton(
                    //                       onPressed: (){
                    //
                    //                         if(!isAvailable){
                    //
                    //                           goOnline();
                    //                           locationUpdates();
                    //
                    //                           setState(() {
                    //
                    //                             isAvailable = true;
                    //
                    //                           });
                    //                           Navigator.pop(context);
                    //
                    //
                    //                         }else{
                    //
                    //                              goOffline();
                    //                              setState(() {
                    //
                    //                                isAvailable = false;
                    //
                    //                              });
                    //                              Navigator.pop(context);
                    //
                    //
                    //                         }
                    //
                    //
                    //
                    //
                    //
                    //
                    //
                    //                       },
                    //                       child: Text("Confirm"),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               )
                    //             ],
                    //           ),
                    //         ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
