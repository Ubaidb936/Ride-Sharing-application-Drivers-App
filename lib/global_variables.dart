
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

String mapKey = 'AIzaSyDbmMbj3Omv_K_HtaeubR3Q_c2sdxLWRHU';
String mapBoxKey = 'pk.eyJ1IjoidWJhaWRiaGF0IiwiYSI6ImNraTdzYWR1ZjFsaXAydHFzaWpvZWgyeWcifQ.QUnypVOXlinI5rb7rJqLyQ';
final auth = FirebaseAuth.instance;

final currentUser = auth.currentUser;

//https://api.mapbox.com/geocoding/v5/mapbox.places/-73.989,40.733.json?access_token=