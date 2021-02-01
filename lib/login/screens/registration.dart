import 'package:drivers_app/DriversView/screens/MainPage.dart';
import 'package:drivers_app/login/screens/login_page.dart';
import 'package:drivers_app/login/screens/vehicle_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:drivers_app/login/widgets/custon_input_field.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Registration extends StatefulWidget {
  static String id = 'registration';
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  var fullNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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


  void registerUser() async {
    //showLoaderDialog(context);
    final User user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).catchError((ex) {
      FirebaseException thisEx = ex;
      showSnackBar(thisEx.message);
    })).user;

    if (user != null) {
      ///problem here
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference()
          .child('drivers/${user.uid}');


      Map userMap = {

        'fullName': fullNameController.text,
        'phoneNumber': '+91'+ phoneNumberController.text,
        'email': emailController.text
      };

      newUserRef.set(userMap);

      Navigator.pushNamed(context, VehicleInfo.id);

    }

    //Navigator.pop(context);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
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


                CustomInputField(textController: fullNameController,
                  textInputType: TextInputType.name,
                  hintText: 'FullName',
                  obscureText: false,
                  icon: Icon(Icons.person),
                ),

                SizedBox(height: 20),

                CustomInputField(textController: phoneNumberController,
                  textInputType: TextInputType.phone,
                  hintText: 'PhoneNumber',
                  obscureText: false,
                  icon: Icon(Icons.phone),

                ),
                SizedBox(height: 20),

                CustomInputField(textController: emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Email',
                  obscureText: false,
                  icon: Icon(Icons.email),
                ),
                SizedBox(height: 20),

                CustomInputField(textController: passwordController,
                  textInputType: TextInputType.name,
                  hintText: 'Password',
                  obscureText: true,
                  icon: Icon(FontAwesomeIcons.userSecret),
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
                  return;
                }

                if (fullNameController.text.length < 3) {
                  showSnackBar('Please enter your full name');
                  return;
                }


                if (phoneNumberController.text.length != 10) {
                  showSnackBar('please enter 10 digit phoneNumber');
                  return;
                }


                if (!(emailController.text.contains('@') && emailController.text.contains('.com'))) {
                  showSnackBar('please enter valid email addrees');
                  return;
                }
                //print(phoneNumberController.text);
                registerUser();
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Already have a account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.id);
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )


        ],

      ),

    );
  }
}
