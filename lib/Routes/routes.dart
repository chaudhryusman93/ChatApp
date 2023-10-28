// import 'package:chatter/pages/RegisterationPage.dart';
// // import 'package:chatter/pages/chatPage.dart';
// import 'package:chatter/pages/homePage.dart';
// import 'package:chatter/pages/otpPage.dart';
// import 'package:chatter/pages/userProfile.dart';
// import 'package:flutter/material.dart';

// Route onGenerateRoute(RouteSettings settings) {
//   if (settings.name == RegistrationPage.pageName) {
//     return MaterialPageRoute(
//       builder: (context) => const RegistrationPage(),
//     );
//   } else if (settings.name == OtpPage.pageName) {
//     return ScaleFadeTransition(page: OtpPage(), settings: settings);
//   } else if (settings.name == UserProfile.pageName) {
//     return ScaleFadeTransition(page: const UserProfile(), settings: settings);
//   } else {
//     return ScaleFadeTransition(page: const HomePage());
//   }
//   //else {
//   //   return ScaleFadeTransition(page: const ChatScreen(token: ,));
//   // }
// }

// class ScaleFadeTransition extends PageRouteBuilder {
//   ScaleFadeTransition({required this.page, RouteSettings? settings})
//       : super(
//             pageBuilder: (context, animation, reverseAnimation) => page,
//             transitionDuration: const Duration(milliseconds: 500),
//             settings: settings,
//             transitionsBuilder: (context, animation, reverseAnimation, child) =>
//                 FadeTransition(
//                   opacity: animation,
//                   child: ScaleTransition(
//                     scale: CurvedAnimation(
//                         parent: animation, curve: Curves.easeIn),
//                     child: child,
//                   ),
//                 ));

//   final Widget page;
// }
