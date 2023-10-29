import 'dart:async';

import 'package:chatter/modelClasses/ChatModel.dart';
import 'package:chatter/notification/notification.dart';

import 'package:chatter/validators/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utlis/HiveDataBaseUtil.dart';
import 'chatpageprovider.dart';

class ChatScreen extends StatefulWidget {
  final String? name;
  final String? phoneNumber;
  final String? token;
  final int index;

  const ChatScreen({
    Key? key,
    this.name,
    required this.token,
    this.phoneNumber,
    required this.index,
  }) : super(key: key);
  static const pageName = '/chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with FormValidationMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();
  late Future<List<UserChatModel>> listUserChatModel;
  // Add User messages to firestore
  Future<void> addUserMessages(
      {String? messages,
      String? phNumber,
      String? currentDate,
      String? currentTime,
      String? timeStamp,
      String? docId}) async {
    await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(docId.toString())
        .collection('Messages')
        .doc()
        .set({
      'messages': messages,
      'phoneNumber': phNumber,
      'currentDate': currentDate,
      'currentTime': currentTime,
      'isSeen': false,
      'timeStamp': timeStamp,
      'timeStampSinceMicro': DateTime.now().microsecondsSinceEpoch
    });
  }

  // Fetch Data from localdatabase
  void getMessages() {
    String x = _auth.currentUser!.phoneNumber!;
    int senderPhoneNumber = int.parse(x.substring(3, 12));
    int receiverPhoneNumber = int.parse(widget.phoneNumber!.substring(3, 12));
    int docId = senderPhoneNumber + receiverPhoneNumber;
    listUserChatModel = HiveDataBaseUtil.getAllChats(docId.toString());
  }

  // Listen messages and add to LocalDataBase
  void listenMessages(int timeStamp, BuildContext context) {
    String x = _auth.currentUser!.phoneNumber!;
    int senderPhoneNumber = int.parse(x.substring(3, 12));
    int receiverPhoneNumber = int.parse(widget.phoneNumber!.substring(3, 12));
    int docId = senderPhoneNumber + receiverPhoneNumber;
    ChatPageProvider chatPageProvider =
        Provider.of<ChatPageProvider>(context, listen: false);
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(docId.toString())
        .collection('Messages')
        .orderBy('timeStampSinceMicro', descending: false)
        .snapshots()
        .listen((event) async {
      if (event.docChanges.length == 1) {
        DocumentChange element = event.docChanges[0];
        Map<String, dynamic> map = element.doc.data() as Map<String, dynamic>;
        String message = map['messages'];

        String timeStamp = map['timeStampSinceMicro'].toString();
        String phoneNo = map['phoneNumber'];
        bool isSeen = map['isSeen'] as bool;
        String receivedTime = map['currentTime'];

        if (phoneNo == x.toString() && !isSeen) {
          print("received");
          await element.doc.reference.update({'isSeen': true});
          chatPageProvider.addToLocalDataBase(
              message, widget.phoneNumber!, x, receivedTime, docId.toString());
        }
      } else {
        for (var element in event.docChanges) {
          Map<String, dynamic> map = element.doc.data() as Map<String, dynamic>;
          String message = map['messages'];

          String timeStamp = map['timeStampSinceMicro'].toString();
          String phoneNo = map['phoneNumber'];
          bool isSeen = map['isSeen'] as bool;
          String receivedTime = map['currentTime'];

          if (phoneNo == x.toString() && !isSeen) {
            print("received");
            await element.doc.reference.update({'isSeen': true});
            chatPageProvider.addToLocalDataBase(message, widget.phoneNumber!, x,
                receivedTime, docId.toString());
          }
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    ChatPageProvider chatPageProvider =
        Provider.of<ChatPageProvider>(context, listen: false);
    chatPageProvider
        .getChats(_auth.currentUser!.phoneNumber!, widget.phoneNumber!)
        .then((value) {
      if (!chatPageProvider.isListnerSubscribledList[widget.index]) {
        listenMessages(
          DateTime.now().microsecondsSinceEpoch,
          context,
        );
        chatPageProvider.isListnerSubscribledList[widget.index] = true;
      }
    });
    // final clientHeight = screenHeight - kToolbarHeight;
    //  to get current Date
    DateTime dateAndTime = DateTime.now();
    String dateNow =
        "${dateAndTime.day}-${dateAndTime.month}-${dateAndTime.year}";
    String timeNow =
        '${dateAndTime.hour % 12 == 0 ? 12 : dateAndTime.hour % 12}:${dateAndTime.minute.toString().padLeft(2, '0')} ${dateAndTime.hour < 12 ? 'AM' : 'PM'}';
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(widget.name!),
      ),
      body: Column(
        children: [
          Expanded(child: Consumer<ChatPageProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: value.listChatModel.length,
                reverse: true,
                itemBuilder: (context, index) {
                  UserChatModel userChatModel = value.listChatModel[index];

                  final isSender = userChatModel.phoneNo ==
                      FirebaseAuth.instance.currentUser!.phoneNumber;

                  final alignment =
                      isSender ? Alignment.centerLeft : Alignment.centerRight;

                  return Padding(
                      padding: EdgeInsets.only(
                          right: isSender ? 0.03 : screenWidth * 0.05,
                          left: isSender ? screenWidth * 0.05 : 0.03,
                          bottom: screenHeight * 0.03,
                          top: screenHeight * 0.01),
                      child: Column(
                        children: [
                          // Message
                          Align(
                            alignment: alignment,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.023),
                              decoration: BoxDecoration(
                                borderRadius: isSender
                                    ? BorderRadius.only(
                                        topRight:
                                            Radius.circular(screenWidth * 0.04),
                                        bottomRight:
                                            Radius.circular(screenWidth * 0.04),
                                        bottomLeft:
                                            Radius.circular(screenWidth * 0.04))
                                    : BorderRadius.only(
                                        topLeft:
                                            Radius.circular(screenWidth * 0.04),
                                        bottomLeft:
                                            Radius.circular(screenWidth * 0.04),
                                        bottomRight: Radius.circular(
                                            screenWidth * 0.04)),
                                color: isSender ? Colors.green : Colors.blue,
                              ),
                              child: Text(userChatModel.message,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.04,
                                  )),
                            ),
                          ),

                          // currentTime
                          Align(
                            alignment: alignment,
                            child: Text(userChatModel.dateTime,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenWidth * 0.033)),
                          )
                        ],
                      ));
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: emptyValidation,
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    //generating room id
                    String x = _auth.currentUser!.phoneNumber!;
                    int senderPhoneNumber = int.parse(x.substring(3, 12));
                    int receiverPhoneNumber =
                        int.parse(widget.phoneNumber!.substring(3, 12));
                    int chatRoom = senderPhoneNumber + receiverPhoneNumber;
                    String timeNow =
                        '${dateAndTime.hour % 12 == 0 ? 12 : dateAndTime.hour % 12}:${dateAndTime.minute.toString().padLeft(2, '0')} ${dateAndTime.hour < 12 ? 'AM' : 'PM'}';
                    //adding value to localdatabase
                    chatPageProvider.addToLocalDataBase(_messageController.text,
                        x, widget.phoneNumber!, timeNow, chatRoom.toString());

                    //adding value to Firebase

                    addUserMessages(
                        messages: _messageController.text,
                        phNumber: widget.phoneNumber,
                        currentDate: dateNow,
                        currentTime: timeNow,
                        timeStamp: dateAndTime.toString(),
                        docId: chatRoom.toString());
                    //send push notification
                    triggerNotifiation(
                        tittle: widget.name!,
                        body: _messageController.text,
                        tokenId: widget.token);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
