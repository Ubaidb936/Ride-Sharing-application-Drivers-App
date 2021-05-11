import 'package:drivers_app/drivers_View/datamodels/ride_details.dart';
import 'package:drivers_app/drivers_View/helper/helpermethods.dart';
import 'package:drivers_app/drivers_View/screens/MainPage.dart';
import 'package:drivers_app/drivers_View/screens/driver_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {



  RideDetails tripDetails;

  NotificationDialog({this.tripDetails});

  void checkAvailability(context) async{



    final ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true );
    pr.style(message: 'Aceepting ride');
    await pr.show();

    DatabaseReference checkRef = FirebaseDatabase.instance.reference().child('drivers/${currentUser.uid}/newTrip');

    checkRef.once().then((DataSnapshot snapshot) async{

      String newTrip = '';
      if(snapshot.value != null){

        newTrip = snapshot.value.toString();

      }else{

        Toast.show("Trip not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

      await pr.hide();
      Navigator.pop(context);


      if(newTrip == tripDetails.rideId){

         ///INCOMPLETE
        checkRef.set('Accepted');
        HelperMethod.disableHomeTabLocationUpdates();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DriverConfig(tripDetails: tripDetails)),
        );


        //Toast.show("Trip accepted", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);


      }else if(newTrip == 'cancelled'){

        Toast.show("Trip Cancelled", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

      }else if(newTrip == 'Timeout'){
        Toast.show("Trip timed out", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else{

        Toast.show("Trip not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,

      child: Container(
        height: 400,
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(4)

        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              SizedBox(

                height: 20,

              ),

              Image.asset('assets/images/TripRequestDialogImage.png', height: 100, width:100),


              SizedBox(

                height: 10,

              ),

              Text("NEW TRIP REQUEST" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

              SizedBox(

                height: 10,

              ),
              Row(

                children: [
                  Image.asset('assets/images/pickicon.png'),
                  SizedBox(width: 20,),
                  Expanded(child: Container(child: Text(tripDetails.pickup))),
              ],),

              SizedBox(

                height: 10,

              ),

              Row(

                children: [

                  Image.asset('assets/images/desticon.png'),
                  SizedBox(width: 20,),
                  Expanded(child: Container(child: Text(tripDetails.destination))),
                ],),

              SizedBox(

                height: 20,

              ),

              Divider(
                thickness: 1,
              ),
              SizedBox(

                height: 20,

              ),

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Container(

                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10)
                    ),

                    child: FlatButton(

                      onPressed: () async{

                        assetAudioPlayer.stop();
                        checkAvailability(context);

                      },
                      child: Text("Confirm"),



                    ),

                  ),
                  Container(

                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: FlatButton(

                      onPressed: (){
                        assetAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),



                    ),

                  )



                ],

              )




            ],


          ),
        ),

      ),


    );
  }
}
