import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/drivers_View/widgets/dialog.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/global_variables.dart';



Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) {


  FlutterNotificationChannel flutterNotificationChannel = FlutterNotificationChannel();
  flutterNotificationChannel.initialize();
  return flutterNotificationChannel._showNotification(message);
}


class FlutterNotificationChannel{


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initialize(){



    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: null);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);


  }
  Future onSelectNotification(String payload) async{

    await flutterLocalNotificationsPlugin.cancelAll();

  }

  Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
    new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'new message arived',
      'hello every one',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }




}


class PushNotificationsService {

  final FirebaseMessaging fcm = FirebaseMessaging();




  Future initialize(context) async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {

        String rideId = message["data"]["ride_id"];
        getRideId(rideId, context);
      },
      //onBackgroundMessage: myBackgroundHandler,
      onLaunch: (Map<String, dynamic> message) async {
        AssetsAudioPlayer.newPlayer().open(
          Audio("assets/audios/alert.mp3"),
          autoStart: true,
          showNotification: true,
        );
        String rideId = message["data"]["ride_id"];
        getRideId(rideId, context);
      },
      onResume: (Map<String, dynamic> message) async {
        AssetsAudioPlayer.newPlayer().open(
          Audio("assets/audios/alert.mp3"),
          autoStart: true,
          showNotification: true,
        );
        String rideId = message["data"]["ride_id"];
        getRideId(rideId, context);
      },
    );
  }


  void getRideId(String id, context) async {
    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child(
        "rideRequests/$id");
    String pickUp;
    String destination;
    await rideRef.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot.value != null) {

        assetAudioPlayer = AssetsAudioPlayer();

        assetAudioPlayer.open(
          Audio("assets/audios/alert.mp3"),
          showNotification: true,
          autoStart: true
        );

        //assetAudioPlayer.play();

        pickUp = snapshot.value["pickUp"];
        destination = snapshot.value["destination"];


        showDialog(context: context, builder: (BuildContext context) =>NotificationDialog(pickUp: pickUp, destination: destination, rideId: id,));




      }
    });
  }


    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //
    //
    //
    //         return AlertDialog(
    //           title: Text('New Trip Request'),
    //           content: Column(
    //             children: [
    //               Text(
    //                   'Pick Up location:' + pickUp
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Text(
    //                   'drop location:' + drop
    //               )
    //             ],
    //           ),
    //           actions: <Widget>[
    //             FlatButton(
    //               child: Text('Confirm'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //             FlatButton(
    //               child: Text('Decline'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         );
    //       });
    //
    //
    // }


    Future<String> getToken() async {
      String token = await fcm.getToken();
      currentUser = FirebaseAuth.instance.currentUser;

      print("---------------------------------------");
      print(token);
      DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child(
          'drivers/${currentUser.uid}/token');
      tokenRef.set(token);

      fcm.subscribeToTopic("alldrivers");
      fcm.subscribeToTopic("allriders");


      return token;
    }
  }



