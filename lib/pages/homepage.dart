import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refresher/auth/backend.dart';
import 'package:refresher/auth/googleauth.dart';
import 'package:refresher/pages/cameraservices.dart';
import 'package:refresher/widgets/containerforlecs.dart';

import '../auth/gemini.dart';
import '../data/data.dart';
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => homepageState();
}

class homepageState extends State<homepage> {

  bool _showButton = true;
  Timer? _timer;
  List<String> documentIds = [];
  List<String> documentNamess = [];
  Future<void> fetchDocuments() async {
    for (int i = 0; i < 200; i++)
      print(200);
    Map<String, String>? user = AuthService().getgoogleUserDetails() as Map<String, String>?;

    documentIds.clear();
    documentNamess.clear();
    if (user != null) {
      String? email = user["email"];
      print(email);
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
          'users').doc(email).collection('lectures').get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        print(doc.id);
        documentIds.add(doc.id);
        documentNamess.add(doc['Name']);
      }
      setState(() {


      });
    }
    else {
      print("55555555555555555555555555555555");
    }
  }

  @override
  initState() {
    super.initState();
    loadDocuments();
    if(!mounted)
    _resetTimer();
    refreshNotifier.addListener(() {
      if (refreshNotifier.value) {
        if(!mounted) return;
        setState(() {
          fetchDocuments();
        }); // 🔄 Refresh UI when the value changes
        refreshNotifier.value = false; // Reset value

      }
    });
  }




  Future<void> loadDocuments() async {
    await fetchDocuments(); // Now you can use await!
  }

  void refreshgui() {
    fetchDocuments();
  }

  void _resetTimer() {
    _timer?.cancel(); // Cancel existing timer
    setState(() => _showButton = true); // Show button on interaction
    floathider.value=true;
    _timer = Timer(Duration(seconds: 5), () { // Hide after 5 sec
      setState(() => _showButton = false);
      floathider.value=false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cleanup timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenlength = MediaQuery
        .of(context)
        .size
        .height;

    return ValueListenableBuilder(
      valueListenable: refreshNotifier,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: _resetTimer, // Tap anywhere to reset timer
          onPanUpdate: (details) {
            _resetTimer(); // Swipe anywhere to reset timer
          },
          child: Stack(
            children: [
              Image.asset(
                'assets/images/bg1.webp',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      _resetTimer(); // Reset timer when user scrolls
                      return false; // Return false to allow normal scrolling
                    },
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: documentIds.length,
                      itemBuilder: (context, index) {
                        return SafeArea(
                          child: containerforlecs(
                            documentIds[index],
                            documentNamess[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  }