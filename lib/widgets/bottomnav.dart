import 'package:flutter/material.dart';
import 'package:refresher/data/data.dart';

class navbar extends StatefulWidget {
  const navbar({Key? key}) : super(key: key);

  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPagenotifier,
      builder: (context, value, child) => ClipRRect(
        borderRadius: BorderRadius.circular(25), // Smooth rounded edges
        child: NavigationBar(
          backgroundColor: Colors.white, // Clean background
          indicatorColor: Colors.blueAccent.withOpacity(0.2), // Soft highlight
          height: 65, // Adjust height for better look
          surfaceTintColor: Colors.transparent, // Avoid default tint
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, size: 28, color: Colors.blue),
              selectedIcon: Icon(Icons.home, size: 32, color: Colors.blueAccent),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.list, size: 28, color: Colors.blue),
              selectedIcon: Icon(Icons.camera_alt_outlined,
                  size: 32, color: Colors.blueAccent),
              label: "To Do List",
            ),
          ],
          selectedIndex: selectedPagenotifier.value,
          onDestinationSelected: (value1) {
            setState(() {
              selectedPagenotifier.value = value1;
            });
          },
        ),
      ),
    );
  }
}


