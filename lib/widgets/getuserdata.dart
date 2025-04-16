import"package:flutter/material.dart";

import "../auth/googleauth.dart";

Future<String?> getuser() async {
  Map<String, String>? user = await AuthService().getgoogleUserDetails() as Map<String, String>?;

  if (user?["username"] != "No Name") {
    return user?["username"];
  } else {
    return await AuthService().getusername(user!["email"]!);
  }
}

@override
Widget build(BuildContext context) => FutureBuilder<String?>(
    future: getuser(), // Call the async function
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading..."); // Show a loading text while waiting
      } else if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}"); // Show error if something goes wrong
      } else {
        return Text(snapshot.data ?? "No Username Found"); // Display the username
      }
    },
  );