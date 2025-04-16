import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class backendservices {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adduser   (UserCredential u,String username)
  async {

    if(u!=null&&u.user!=null)
      {

        await FirebaseFirestore.instance.collection('users').doc(u.user?.email).set(
            {
              'email': u.user?.email,
              'username': username
            }
        );
      }

  }
  Future<void> addlecture(String Lecturename,TimeOfDay? fromtime,TimeOfDay? totime,String email  )
  async {
    DateTime now = DateTime.now();

    DateTime? fromDateTime = fromtime != null
        ? DateTime(now.year, now.month, now.day, fromtime.hour, fromtime.minute)
        : null;

    DateTime? toDateTime = totime != null
        ? DateTime(now.year, now.month, now.day, totime.hour, totime.minute)
        : null;
    await FirebaseFirestore.instance.collection('users').doc(email).collection("lectures").doc(Lecturename).set(
        {
          'Name': Lecturename,
          'from': fromDateTime,
          'to':toDateTime
        }
    );
  }
  Future<void> addimage(File imageFile,List<String>topics,String email )
  async {
    print("a7A");
    TimeOfDay nowTime = TimeOfDay.now();
    int nowMinutes = nowTime.hour * 60 + nowTime.minute; // Convert to minutes

    // Fetch all documents (since Firestore can't compare only time)
    print(email);
    QuerySnapshot querySnapshot = await _firestore.collection('users').doc(email).collection('lectures').get();
    for(int i=0;i<10;i++)
      print("100");
    List<QueryDocumentSnapshot> matchingDocs = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Timestamp fromTimestamp = doc["from"];
      Timestamp toTimestamp = doc["to"];
      print(fromTimestamp );
      // Convert Firestore Timestamp to TimeOfDay
      TimeOfDay fromTime = _timestampToTimeOfDay(fromTimestamp);
      TimeOfDay toTime = _timestampToTimeOfDay(toTimestamp);
      print(fromTime.hour);
      // Convert to total minutes since midnight
      int fromMinutes = fromTime.hour * 60 + fromTime.minute;
      int toMinutes = toTime.hour * 60 + toTime.minute;

      // Handle both normal and cross-midnight cases
      bool isWithinRange = (fromMinutes <= toMinutes)
          ? (nowMinutes >= fromMinutes && nowMinutes <= toMinutes)  // Normal case
          : (nowMinutes >= fromMinutes || nowMinutes <= toMinutes); // Cross-midnight

      if (isWithinRange) {
        matchingDocs.add(doc);
      }
    }
    String base64Image = await _convertImageToBase64(imageFile);
    for (QueryDocumentSnapshot doc1 in matchingDocs) {

      await _firestore.collection('users')
          .doc(email)
          .collection('lectures')
           .doc(doc1.id)
           .collection('images')
          .add({
        "image_base64": base64Image,
        "topics": topics,
        });

      }
          }
  TimeOfDay _timestampToTimeOfDay(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert to DateTime
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
  Future<String> uploadImageToStorage(File imageFile, String docId) async {
    String filePath = "images/$docId/${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance.ref().child(filePath);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
  Future<String> _convertImageToBase64(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Failed to decode image.");
    }

    int quality = 70; // Start with high quality
    int maxSize = 800 * 1024; // 800 KB
    Uint8List compressedBytes = Uint8List.fromList(img.encodeJpg(image, quality: quality));

    // **Step 1: Reduce JPEG quality only (Keeps resolution high)**

      compressedBytes = Uint8List.fromList(img.encodeJpg(image, quality: quality));



    // **Step 2: Resize only if necessary (Keeps quality high)**
      double scaleFactor = 0.85; // Reduce size gradually
        int newWidth = (image.width * scaleFactor).round();
        int newHeight = (image.height * scaleFactor).round();
        image = img.copyResize(image, width: newWidth, height: newHeight);
        compressedBytes = Uint8List.fromList(img.encodeJpg(image, quality: quality));




    return base64Encode(compressedBytes);
  }
}


