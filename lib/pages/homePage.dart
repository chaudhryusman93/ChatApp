import 'package:chatter/drawer/drawer.dart';
import 'package:chatter/pages/RegisterationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modelClasses/ChatUsers.dart';
import 'chatPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const pageName = '/Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    // final ScreenWidth = ScreenSize.width;
    final ScreenHeight = ScreenSize.height;
    final ClientHeight = ScreenHeight - kToolbarHeight;
    ;
    Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber',
            isNotEqualTo: firebaseAuth.currentUser!.phoneNumber.toString())
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('chats'),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.grey,
        child: UserDrawer(),
      ),
      backgroundColor: Colors.grey,
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> map =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              ModelClassForProfileData chatUser =
                  ModelClassForProfileData.fromMap(map);
              return Padding(
                padding: EdgeInsets.only(top: ClientHeight * 0.005),
                child: Card(
                  shadowColor: Colors.blue,
                  color: Colors.grey,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ChatScreen(
                            phoneNumber: chatUser.phoneNumber,
                            name: chatUser.name,
                            token: chatUser.token,
                          );
                        },
                      ));
                    },
                    leading: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(chatUser.imageUrl!)),
                    title: Text(chatUser.name!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
