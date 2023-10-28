// import 'package:chatter/Routes/routes.dart';
import 'dart:developer';

import 'package:chatter/notification/notification.dart';
import 'package:chatter/pages/RegisterationPage.dart';
import 'package:chatter/pages/homePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage remoteMessage,
) async {
  log('FirebaseMessagingUtil::_firebaseMessagingBackgroundHandler, ${remoteMessage.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      // apiKey: "AIzaSyD7-nPiEkX4TX0aPPSKmY_fGQcPB_7ZZ3w",
      // projectId: "chatter-c452b",
      // messagingSenderId: "974407294666",
      // appId: "1:974407294666:web:ee3da34869dadc757c1e33")
      );

  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // User? _user;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  // Storing user information securely
  Future<void> storeUserInformation(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Check if the user is already authenticated
  bool checkUserLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      phoneNumberController.text =
          FirebaseAuth.instance.currentUser!.phoneNumber.toString();
      return true; // User is already authenticated, navigate to the home screen
    } else {
      // User not authenticated, show the login screen
      return false;
    }
  }

  // Once the user is authenticated successfully, store the user information and navigate to the home screen
  void onAuthenticationSuccess(UserCredential userCredential) {
    final user = userCredential.user;
    if (user != null) {
      storeUserInformation(user.uid); // Store user information securely
      Navigator.of(context).pushNamed(HomePage.pageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: onGenerateRoute,
      theme: ThemeData(
        useMaterial3: true,
        // Define your app's theme
      ),
      home: checkUserLoggedIn() ? const HomePage() : const RegistrationPage(),
    );
  }
}
