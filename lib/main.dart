import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:refresher/auth/loggedinornot.dart';
import 'package:refresher/data/data.dart';
import 'package:refresher/firebase_options.dart';
import 'package:refresher/pages/welcomescreen.dart';
import 'package:refresher/widgets/bottomnav.dart';
import 'package:refresher/widgets/welcomebutton.dart';
import 'package:refresher/widgets/widgettree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(valueListenable: selectmood, builder:  (context, value, child) {
      Brightness b=Brightness.light;
      if(value==false)
      {
        b=Brightness.light;
      }
      else
      {
        b=Brightness.dark;
      }
      return MaterialApp(
           theme: ThemeData(
             brightness: b
           ),
          debugShowCheckedModeBanner: false,

          title: 'Flutter Demo',


          home: customscafold()
      );
    },);
  }
}

