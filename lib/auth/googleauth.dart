import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return null; // User canceled sign-in

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for the user
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in and get user data
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      return user; // Return the user object
    } catch (e) {
      print("Error signing in with Googlhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhe: $e");
      return null;
    }
  }
    Future<int> handleGoogleSignIn() async {
      AuthService authService = AuthService();
      User? user = await authService.signInWithGoogle();

      if (user != null) {
        String username = user.displayName ?? "No Name";
        String email = user.email ?? "No Email";
        String uid = user.email ??"No EMAIL";

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,

        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

        print("User saved to Firestore: $username - $email");
      } else {
        print("Google Sign-In failed");
      }
      return 0;
    }
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Get username and email if logged in
  Map<String, String>? getgoogleUserDetails() {
    User? user = getCurrentUser();
    if (user != null) {
      return {
        "username": user.displayName ?? "No Name",
        "email": user.email ?? "No Email",
      };
    }

    return null; // User not logged in
  }
  Future<String> getusername(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection('users').doc(email);
    print(docRef);
    try {
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        String myField = doc.get('username'); // 🔥 Replace with your actual field name
        print("Retrieved field: $myField");
        return myField;
      } else {
        print("Document does not exist!");
      }
    } catch (e) {
      print("Error getting document: $e");
    }
    return "";
  }
  }

