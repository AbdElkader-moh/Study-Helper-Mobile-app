import 'package:flutter/material.dart';
import 'package:refresher/data/data.dart';
import 'package:refresher/pages/homepage.dart';
import '../auth/backend.dart';
import '../auth/googleauth.dart';
class floatadd extends StatelessWidget {

  // Constructor receiving the GlobalKey<HomePageState> for HomePageState

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(heroTag: "unique_fab_1",onPressed: () {TextEditingController titleController = TextEditingController();
    TimeOfDay? fromTime;
    TimeOfDay? toTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Add Schedule",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                    title: Text(fromTime == null ? "Select From Time" : "From: ${fromTime!.format(context)}"),
                    leading: Icon(Icons.access_time),
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          fromTime = picked;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),

                  // To Time Picker
                  ListTile(
                    title: Text(toTime == null ? "Select To Time" : "To: ${toTime!.format(context)}"),
                    leading: Icon(Icons.access_time),
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          toTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String title = titleController.text;
                    String from = fromTime?.format(context) ?? "Not Selected";
                    String to = toTime?.format(context) ?? "Not Selected";

                    print("Added: $title from $from to $to");
                    Map<String, String>? user = await AuthService().getgoogleUserDetails() as Map<String, String>?;



                    if(user!=null)
                    {

                      String? email=user["email"];
                      backendservices().addlecture(title,fromTime ,toTime,email!   );

                    }
                    else
                    {
                      print("55555555555555555555555555555555");
                    }
                    refreshNotifier.value=true;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: Text("Add", style: TextStyle(fontSize: 18)),
                ),
              ],
            );
          },
        );
      },
    );
    },
      shape: CircleBorder(), // Ensures the button is round
      backgroundColor: Colors. white60, // Futuristic theme color
      foregroundColor: Colors.black, // White icon for contrast
      child: Icon(Icons.add, size: 32), );
  }
}

