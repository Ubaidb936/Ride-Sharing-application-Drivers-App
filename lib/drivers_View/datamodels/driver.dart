import 'package:firebase_database/firebase_database.dart';

class DriverDetails{

  String email;
  String fullName;
  String phoneNumber;
  String vehicleColor;
  String vehicleName;
  String vehicleNumber;

   DriverDetails({this.email, this.fullName, this.phoneNumber, this.vehicleColor, this.vehicleName, this.vehicleNumber });

   DriverDetails.fromSnapshot(DataSnapshot snapshot){
      email = snapshot.value['email'].toString();
      fullName = snapshot.value['fullName'].toString();
      phoneNumber = snapshot.value['phoneNumber'].toString();
      vehicleName = snapshot.value['vehicleInfo']['vehicleName'].toString();
      vehicleColor = snapshot.value['vehicleInfo']['vehicleColor'].toString();
      vehicleNumber = snapshot.value['vehicleInfo']['vehicleNumber'].toString();
   }




}