import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/googleauth.dart';
import '../data/data.dart';
import '../pages/homepage.dart';
void showPopupMenu(BuildContext context, TapDownDetails details, String? user, String docid) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        0,
        0
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // Rounded edges
    ),
    color: Colors.white, // Background color
    items: [
      PopupMenuItem(
        child: _menuItem1(Icons.edit, "Update", Colors.blue, context,user!,docid),
      ),
      PopupMenuItem(
        child: _menuItem2(Icons.delete, "Delete", Colors.red, context,user!,docid),
      ),
    ],
  );
}

Widget _menuItem1(IconData icon, String text, Color color, BuildContext context, String email, String docid) {
  return InkWell(
    borderRadius: BorderRadius.circular(12), // Smooth ripple effect
    onTap: () async {
      Map<String, dynamic>? lectureDetails = await getLectureDetails(docid, email!);
      print(docid);
      if (lectureDetails != null) {
        String title = lectureDetails["Name"];
        Timestamp fromTimestamp = lectureDetails["from"];
        Timestamp toTimestamp = lectureDetails["to"];
       await showUpdateDialog(context, docid, title, fromTimestamp, toTimestamp);
      print("$text clicked");
    }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}
Widget _menuItem2(IconData icon, String text, Color color, BuildContext context,String email,String docid) {
  return InkWell(
    borderRadius: BorderRadius.circular(12), // Smooth ripple effe0000000000000ct
    onTap: () {

      Navigator.pop(context);
      _showDeleteDialog(context,email ,docid);
      print("$text clicked");
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}
void _showDeleteDialog(BuildContext context, String email,String docId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Delete Document?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this document? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              BuildContext parentContext = context; // Store the valid context before awaiting
              Navigator.pop(parentContext); // Close the dialog

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(email)
                  .collection('lectures')
                  .doc(docId)
                  .delete();
              refreshNotifier.value=true;

            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),

          ),
        ],
      );
    },
  );
}
Future<void> updateLecture(String docId, String title, TimeOfDay fromTime, TimeOfDay toTime, String email) async {
  try {
    DateTime now = DateTime.now(); // Get the current date

    DateTime fromDateTime = DateTime(now.year, now.month, now.day, fromTime.hour, fromTime.minute);
    DateTime toDateTime = DateTime(now.year, now.month, now.day, toTime.hour, toTime.minute);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('lectures')
        .doc(docId)
        .update({
      'Name': title,
      'from': Timestamp.fromDate(fromDateTime), // Store as Timestamp
      'to': Timestamp.fromDate(toDateTime),
    });
    refreshNotifier.value = true;


    print("Document updated successfully!");
  } catch (e) {
    print("Error updating document: $e");
  }
}
int showUpdateDialog(BuildContext context, String docId, String title, Timestamp fromTimestamp, Timestamp toTimestamp) {
  TextEditingController titleController = TextEditingController(text: title);
  // Convert Firestore Timestamp to TimeOfDay
  DateTime fromDateTime = fromTimestamp.toDate();
  DateTime toDateTime = toTimestamp.toDate();
  TimeOfDay updatedFromTime = TimeOfDay(hour: fromDateTime.hour, minute: fromDateTime.minute);
  TimeOfDay updatedToTime = TimeOfDay(hour: toDateTime.hour, minute: toDateTime.minute);
  print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Update Schedule", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Lecture or Section",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 10),

                // From Time Picker
                ListTile(
                  title: Text(updatedFromTime == null
                      ? "Select From Time"
                      : "From: ${updatedFromTime.format(context)}"),
                  leading: Icon(Icons.access_time),
                  tileColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: updatedFromTime,
                    );
                    if (picked != null) {
                      setState(() {
                        updatedFromTime = picked;
                      });
                    }
                  },
                ),
                SizedBox(height: 10),

                // To Time Picker
                ListTile(
                  title: Text(updatedToTime == null
                      ? "Select To Time"
                      : "To: ${updatedToTime.format(context)}"),
                  leading: Icon(Icons.access_time),
                  tileColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: updatedToTime,
                    );
                    if (picked != null) {
                      setState(() {
                        updatedToTime = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  String updatedTitle = titleController.text;
                  Map<String, String>? user = await AuthService().getgoogleUserDetails() as Map<String, String>?;


                  if (user != null) {
                    String? email = user["email"];
                    await updateLecture(docId, updatedTitle, updatedFromTime, updatedToTime, email!);

                  } else {
                    print("Error: User not found");
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text("Update", style: TextStyle(fontSize: 18)),
              ),
            ],
          );
        },
      );
    },
  );
  return 1;
}
Future<Map<String, dynamic>?> getLectureDetails(String docId, String email) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('lectures')
        .doc(docId)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>; // Return document data
    } else {
      print("Document not found!");
      return null;
    }
  } catch (e) {
    print("Error fetching document: $e");
    return null;
  }
}