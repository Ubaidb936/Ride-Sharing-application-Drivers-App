import 'package:drivers_app/drivers_View/dataProvider/appdata.dart';
import 'package:drivers_app/drivers_View/screens/MainPage.dart';
import 'package:drivers_app/drivers_View/screens/driver_config.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:drivers_app/login/screens/vehicle_info.dart';
import 'package:drivers_app/login/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/login/screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
User currentFirebaseUser;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app;
  try {
    app = await Firebase.initializeApp(
      name: 'db2',
      options: Platform.isIOS || Platform.isMacOS
          ? FirebaseOptions(
        appId: '1:5087372234:ios:d14a9ab3d025fae2d0e533',
        apiKey: 'AIzaSyDbmMbj3Omv_K_HtaeubR3Q_c2sdxLWRHU',
        projectId: 'sumostand-3e4ed',
        messagingSenderId: '5087372234',
        databaseURL: 'https://sumostand-3e4ed.firebaseio.com',
      )
          : FirebaseOptions(
        appId: '1:5087372234:android:c3a7aa9acd32d433d0e533',
        apiKey: 'AIzaSyDODpnkFmUXZJx7tuhV0MC1pVIAxJKFpHY',
        messagingSenderId: '5087372234',
        projectId: 'sumostand-3e4ed',
        databaseURL: 'https://sumostand-3e4ed.firebaseio.com',
      ),
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      app = Firebase.app('db2');
    } else {
      throw e;
    }
  } catch (e) {
    rethrow;
  }




   currentUser = FirebaseAuth.instance.currentUser;
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        initialRoute:(currentUser != null)? MainPage.id:LoginPage.id,
        routes: {

          Registration.id: (context)=> Registration(),
          LoginPage.id: (context) => LoginPage(),
          VehicleInfo.id: (context) => VehicleInfo(),
          MainPage.id: (context)=> MainPage(),
          DriverConfig.id: (context) => DriverConfig()

        },
      ),
    );
  }
}


