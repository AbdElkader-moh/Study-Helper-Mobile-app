import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refresher/pages/settings.dart';
import 'package:refresher/widgets/widgettree.dart';

import '../pages/welcomescreen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const widgettree();
          }

          // user is NOT logged in
          else {
            return const customscafold ();
          }
        },
      ), // StreamBuilder
    ); // Scaffold
  }
}