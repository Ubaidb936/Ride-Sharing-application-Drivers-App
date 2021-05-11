import 'package:drivers_app/drivers_View/screens/tabs/home_tab.dart';
import 'package:drivers_app/drivers_View/screens/tabs/earning_tab.dart';
import 'package:drivers_app/drivers_View/screens/tabs/ratings_tab.dart';
import 'package:drivers_app/drivers_View/screens/tabs/acount_tab.dart';
import 'package:drivers_app/app_colors.dart';
import 'package:drivers_app/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {


  static String id = 'mainPage';
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>  with SingleTickerProviderStateMixin {

  TabController _tabController;
  int selectedIndex = 0;
  void onItemClicked(int index){

      setState(() {
         selectedIndex = index;
        _tabController.index = selectedIndex;
      });

  }

  void getUser(){

   currentUser = FirebaseAuth.instance.currentUser;


   print("------------------------------------------------------");
   print(currentUser.email);




  }

  @override
  void initState() {
    // TODO: implement initState

    getUser();
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [


          HomeTab(),
          EarningsTab(),
          RatingsTab(),
          AccountTab(),

        ],


      ),
      bottomNavigationBar: BottomNavigationBar(

        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Earnings',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Ratings',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',

          ),

        ],
         currentIndex: selectedIndex,
         unselectedItemColor: AppColors.colorIcon,
         selectedItemColor: Colors.orange,
         showSelectedLabels: true,
         showUnselectedLabels: true,
         selectedLabelStyle: TextStyle(fontSize: 12),
         type: BottomNavigationBarType.fixed,
         onTap: onItemClicked,


      ),





    );
  }
}
