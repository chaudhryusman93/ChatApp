import 'package:chatter/validators/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String? name;
  final String? phoneNumber;
  // final String? token;

  const ChatScreen({
    Key? key,
    this.name,
    // required this.token,
    this.phoneNumber,
  }) : super(key: key);
  static const pageName = '/chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with FormValidationMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();

  // Add User messages to firestore
  Future<void> addUserMessages({
    String? messages,
    String? phNumber,
    String? currentDate,
    String? currentTime,
    String? timeStamp,
  }) async {
    String x = _auth.currentUser!.phoneNumber!;
    int senderPhoneNumber = int.parse(x.substring(3, 12));
    int receiverPhoneNumber = int.parse(widget.phoneNumber!.substring(3, 12));
    int docId = senderPhoneNumber + receiverPhoneNumber;
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
      'timeStamp': timeStamp,
    });
  }

  // Fetch Data from Firestore
  Stream<QuerySnapshot> getMessagesStream() {
    String x = _auth.currentUser!.phoneNumber!;
    int senderPhoneNumber = int.parse(x.substring(3, 12));
    int receiverPhoneNumber = int.parse(widget.phoneNumber!.substring(3, 12));
    int docId = senderPhoneNumber + receiverPhoneNumber;
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(docId.toString())
        .collection('Messages')
        .orderBy('timeStamp', descending: true)
        .snapshots();
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
          Expanded(
            child: StreamBuilder(
              stream: getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!.docs;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = data[index].data() as Map<String, dynamic>;

                    final isSender = message['phoneNumber'] ==
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
                                          topRight: Radius.circular(
                                              screenWidth * 0.04),
                                          bottomRight: Radius.circular(
                                              screenWidth * 0.04),
                                          bottomLeft: Radius.circular(
                                              screenWidth * 0.04))
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(
                                              screenWidth * 0.04),
                                          bottomLeft: Radius.circular(
                                              screenWidth * 0.04),
                                          bottomRight: Radius.circular(
                                              screenWidth * 0.04)),
                                  color: isSender ? Colors.green : Colors.blue,
                                ),
                                child: Text(message['messages'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.04,
                                    )),
                              ),
                            ),

                            // currentTime
                            Align(
                              alignment: alignment,
                              child: Text(message['currentTime'],
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenWidth * 0.033)),
                            )
                          ],
                        ));
                  },
                );
              },
            ),
          ),
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
                    addUserMessages(
                        messages: _messageController.text,
                        phNumber: widget.phoneNumber,
                        currentDate: dateNow,
                        currentTime: timeNow,
                        timeStamp: dateAndTime.toString());
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
