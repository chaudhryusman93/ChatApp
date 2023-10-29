// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserChatModel {
  String message;
  String phoneNo;
  String dateTime;
  String timeStamp;
  UserChatModel({
    required this.message,
    required this.phoneNo,
    required this.dateTime,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'phoneNo': phoneNo,
      'dateTime': dateTime,
      'timeStamp': timeStamp,
    };
  }

  factory UserChatModel.fromMap(Map<dynamic, dynamic> map) {
    return UserChatModel(
      message: map['message'] as String,
      phoneNo: map['phoneNo'] as String,
      dateTime: map['dateTime'] as String,
      timeStamp: map['timeStamp'] as String,
    );
  }
}
