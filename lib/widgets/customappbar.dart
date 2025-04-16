import 'package:flutter/material.dart';
import 'package:refresher/auth/googleauth.dart';
import 'package:refresher/pages/settings.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueNotifier<bool> selectmood;
  final IconData icon;
  final Map<String, String>? user;

  CustomAppBar({required this.selectmood, required this.icon, required this.user});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10); // ✅ Correct implementation
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<String?> getuser() async {
    if (widget.user?["username"] != "No Name") {
      return widget.user?["username"];
    } else {
      return await AuthService().getusername(widget.user!["email"]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with rounded bottom
        Container(
          height: 90, // Extending slightly for smooth curve
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyanAccent, Colors.blueAccent], // Smooth Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        // Actual AppBar with FutureBuilder
        AppBar(
          backgroundColor: Colors.transparent, // Make background transparent
          elevation: 0, // Remove shadow for a clean look
          title: FutureBuilder<String?>(
            future: getuser(), // ✅ Fetch username asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading..."); // ✅ Show loading state
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}"); // ✅ Handle errors
              } else {
                return Text(
                  "Hello, ${snapshot.data ?? "Guest"} 👋",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                widget.selectmood.value = !widget.selectmood.value;
              },
              icon: Icon(widget.icon, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => settings()),
                );
              },
              icon: Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

