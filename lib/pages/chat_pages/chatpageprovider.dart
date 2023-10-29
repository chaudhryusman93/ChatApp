import 'package:chatter/modelClasses/ChatModel.dart';
import 'package:chatter/utlis/HiveDataBaseUtil.dart';
import 'package:flutter/material.dart';

class ChatPageProvider extends ChangeNotifier {
  List<UserChatModel> listChatModel = [];
  bool isLoaded = false;
  List<bool> isListnerSubscribledList = [];
  Future<void> getChats(String senderPhoneNo, String receiverPhoneNo) async {
    await getMessages(senderPhoneNo, receiverPhoneNo);
    isLoaded = true;
    notifyListeners();
  }

  // Fetch Data from Firestore
  Future<void> getMessages(String senderPhoneNo, String receiverPhoneNo) async {
    int senderPhoneNumber = int.parse(senderPhoneNo.substring(3, 12));
    int receiverPhoneNumber = int.parse(receiverPhoneNo!.substring(3, 12));
    int docId = senderPhoneNumber + receiverPhoneNumber;
    listChatModel = await HiveDataBaseUtil.getAllChats(docId.toString());
    if (!isLoaded) {
      listChatModel.forEach((element) {
        isListnerSubscribledList.add(false);
      });
    }
  }

  //add to local database
  Future<void> addToLocalDataBase(String message, String senderPhoneNo,
      String receiverPhoneNo, String dateTime, String chatRoom) async {
    UserChatModel userChatModel = UserChatModel(
        message: message,
        phoneNo: receiverPhoneNo,
        dateTime: dateTime,
        timeStamp: DateTime.now().microsecondsSinceEpoch.toString());
    //adding value to localdatabase
    await HiveDataBaseUtil.addChat(userChatModel, chatRoom.toString());
    await getMessages(senderPhoneNo, receiverPhoneNo);
    notifyListeners();
  }
}
