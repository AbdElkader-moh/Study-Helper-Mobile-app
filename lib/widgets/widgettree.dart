import 'package:flutter/material.dart';
import 'package:refresher/data/data.dart';
import 'package:refresher/pages/homepage.dart';
import 'package:refresher/pages/profile.dart';
import 'package:refresher/pages/settings.dart';
import 'package:refresher/widgets/appbar.dart';
import 'package:refresher/widgets/bottomnav.dart';
import 'package:refresher/pages/homepage.dart';
import 'package:refresher/widgets/floating_pointaddbutton.dart';

import '../auth/googleauth.dart';
import 'customappbar.dart';
import 'floatcam.dart';

List <Widget> l1=[homepage(),profile()];
class widgettree extends StatefulWidget {
  const widgettree({Key? key}) : super(key: key);

  @override
  State<widgettree> createState() => _widgettreeState();
}

class _widgettreeState extends State<widgettree> {
  Map<String, String>? user = AuthService().getgoogleUserDetails();
  bool showbutton=false;
  @override
  initState() {
    super.initState();

    floathider.addListener(() {
      showbutton=floathider.value;

      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(valueListenable: selectmood, builder:(context, value2, child) {
      return ValueListenableBuilder(valueListenable: selectedPagenotifier, builder: (context, value, child) {
        return ValueListenableBuilder(valueListenable:floathider , builder:(context,value3,child){

        Color r=Colors.red;
        IconData icon=Icons.light_mode;
        if(value==1)
          r=Colors.red;
        else
          r=Colors.green;
       if(value2==false)
         {
           icon=Icons.light_mode;
         }
       else
         {
           icon=Icons.dark_mode;
         }
        return  Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          bottomNavigationBar: navbar(),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showbutton? floatadd(): SizedBox(),
               SizedBox(
               height: 8,
              ),
               showbutton?  floatcamera(context) :SizedBox(),

            ],
          ),

          appBar:CustomAppBar(selectmood: selectmood, icon: Icons.ice_skating, user:user,),
          

          

          body: l1[value],

        ) ;
      },
      );

    },
    );
    },
    );
  }
}
