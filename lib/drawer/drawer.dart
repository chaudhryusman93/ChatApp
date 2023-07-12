import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/RegisterationPage.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});
  fetchData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneNumberController.text)
        .get();
  }

// For SignOut
  void signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    final ScreenWidth = ScreenSize.width;
    final ScreenHeight = ScreenSize.height;
    final ClientHeight = ScreenHeight - kToolbarHeight;
    return Column(
      children: [
        FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.grey,
              ));
            }

            var data = snapshot.data! as DocumentSnapshot;

            return Column(
              children: [
                //CircleAvatar for Image
                Padding(
                  padding: EdgeInsets.only(
                      top: ClientHeight * 0.06, right: ScreenWidth * 0.09),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: ScreenHeight * 0.07,
                    backgroundImage: NetworkImage('${data['imageUrl']}'),
                  ),
                ),

                // Text for profile
                Padding(
                  padding: EdgeInsets.only(
                      top: ClientHeight * 0.06, right: ScreenWidth * 0.1),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: ClientHeight * 0.032,
                    ),
                  ),
                ),

                // Text for Phone Number
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                            BorderRadius.circular(ScreenWidth * 0.03)),
                    tileColor: Colors.grey,
                    leading: const Icon(Icons.phone, color: Colors.black),
                    title: Text(
                      '${data['phoneNumber']}',
                      style: TextStyle(
                        fontSize: ScreenHeight * 0.03,
                      ),
                    ),
                  ),
                ),

                // Text for Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(ScrollDragController
                                .momentumRetainVelocityThresholdFactor *
                            0.03)),
                    tileColor: Colors.grey,
                    leading: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    title: Text('${data['name']}',
                        style: TextStyle(
                          fontSize: ScreenHeight * 0.03,
                        )),
                  ),
                ),

                // Button for SignOut
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                            BorderRadius.circular(ScreenWidth * 0.03)),
                    tileColor: Colors.grey,
                    leading: const Icon(Icons.undo),
                    iconColor: Colors.black,
                    title: Text(
                      'SignOut',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ClientHeight * 0.026,
                      ),
                    ),
                    onTap: () {
                      signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationPage(),
                          ));
                    },
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
