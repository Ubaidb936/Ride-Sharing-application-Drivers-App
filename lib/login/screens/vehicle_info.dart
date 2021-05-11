import 'package:drivers_app/drivers_View/screens/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:drivers_app/login/widgets/custon_input_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class VehicleInfo extends StatefulWidget {
  static String id = 'vehicleInfo';
  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {

  var vehicleNumberController = TextEditingController();
  var vehicleColourController = TextEditingController();
  var vehicleNameController = TextEditingController();
  var vehicleModelController = TextEditingController();
  User user;


  final FirebaseAuth _auth = FirebaseAuth.instance;


  final GlobalKey<ScaffoldState>scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackBar = SnackBar(content: Text(
      title, textAlign: TextAlign.center, style: TextStyle(fontSize: 20),));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }


  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void currentUer(){


    user = _auth.currentUser;


  }
  void registerVehicle(){


      Map vehicleMap ={


        'vehicleName': vehicleNameController.text,
        'vehicleColor': vehicleColourController.text,
        'vehicleModel': vehicleModelController.text,
        'vehicleNumber': vehicleNumberController.text


      };

      DatabaseReference newVehicleRef = FirebaseDatabase.instance.reference().child('drivers/${user.uid}/vehicleInfo');
      newVehicleRef.set(vehicleMap);
      Navigator.pushNamed(context, MainPage.id);




  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      // backgroundColor: Colors.green,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))

            ),
          ),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(

              children: [


                CustomInputField(
                  textController: vehicleNameController,
                  textInputType: TextInputType.name,
                  hintText: 'Vehicle Name',
                  obscureText: false,

                ),

                SizedBox(height: 20),

                CustomInputField(textController: vehicleColourController,
                  textInputType: TextInputType.name,
                  hintText: 'Vehicle Color',
                  obscureText: false,

                ),
                SizedBox(height: 20),

                CustomInputField(textController: vehicleModelController,
                  textInputType: TextInputType.number,
                  hintText: 'Vehicle Model',
                  obscureText: false,
                ),
                SizedBox(height: 20),

                CustomInputField(textController: vehicleNumberController,
                  textInputType: TextInputType.name,
                  hintText: 'Vehicle Number',
                  obscureText: false,
                ),




              ],
            ),
          ),


          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                var connectivityResult = await (Connectivity()
                    .checkConnectivity());

                if (connectivityResult != ConnectivityResult.wifi &&
                    connectivityResult != ConnectivityResult.mobile) {
                  showSnackBar('check internet connection');
                }

                if (vehicleNameController.text.length < 3) {
                  showSnackBar('Please enter vehicles name');
                }


                if (vehicleColourController.text.length < 3) {
                  showSnackBar('please enter valid color');
                }


                if (vehicleModelController.text.length < 3) {
                  showSnackBar('please enter valid model Number');
                }

                if (vehicleNumberController.text.length < 3) {
                  showSnackBar('please enter valid vehicles Number');
                }
                registerVehicle();
              },

              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        )
                      ]),
                  child: Center(child: Text('Register'))


              ),
            ),
          ),


        ],

      ),

    );
  }
}