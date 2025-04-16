import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/backend.dart';
import '../auth/gemini.dart';
import '../auth/googleauth.dart';
class floatcamera extends StatelessWidget {
 late BuildContext parentContext ;
 floatcamera(BuildContext context)
 {
   this.parentContext=context;
 }


  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return FloatingActionButton(heroTag: "unique_fab_2"
      ,onPressed:  () async {

        final XFile? image = await _picker.pickImage(source: ImageSource.camera);

        if (image == null) {

          return;
        };
        for(int i=0;i<10;i++)
          print("55555555555555555555555");
        File imageFile = File(image.path);
        // Show loading dialog
        showDialog(
          context: parentContext,
          barrierDismissible: false, // Prevent closing while loading
          builder: (context) => const Center(
            child: CircularProgressIndicator(

            ),
          ),
        );
        List<String>s1=await GeminiService().analyzeImage(image);
        Map<String, String>? user = await AuthService().getgoogleUserDetails() as Map<String, String>?;

        if(user!=null) {
          String? email = user["email"];
          print(email);
          for (String s in s1)
            print(s);
          await backendservices().addimage(imageFile, s1, email!);
        }
        if (parentContext.mounted) {
          Navigator.pop(parentContext);
        }



      },


      shape: CircleBorder(), // Ensures the button is round
      backgroundColor: Colors. white60, // Futuristic theme color
      foregroundColor: Colors.black, // White icon for contrast
      child: Icon(Icons.camera_alt, size: 32), );
  }
}
