// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class ChatUser {
//   String? name;
//   String? imageUrl;
//   String? phoneNumber;
//   String? token;
//   ChatUser({
//     this.name,
//     this.imageUrl,
//     this.phoneNumber,
//     this.token,
//   });

//   ChatUser copyWith({
//     String? name,
//     String? imageUrl,
//     String? phoneNumber,
//     String? token,
//   }) {
//     return ChatUser(
//       name: name ?? this.name,
//       imageUrl: imageUrl ?? this.imageUrl,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       token: token ?? this.token,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'imageUrl': imageUrl,
//       'phoneNumber': phoneNumber,
//       'token': token,
//     };
//   }

//   factory ChatUser.fromMap(Map<String, dynamic> map) {
//     return ChatUser(
//       name: map['name'] != null ? map['name'] as String : null,
//       imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
//       phoneNumber:
//           map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
//       token: map['token'] != null ? map['token'] as String : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatUser.fromJson(String source) =>
//       ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'ChatUser(name: $name, imageUrl: $imageUrl, phoneNumber: $phoneNumber, token: $token)';
//   }

//   @override
//   bool operator ==(covariant ChatUser other) {
//     if (identical(this, other)) return true;

//     return other.name == name &&
//         other.imageUrl == imageUrl &&
//         other.phoneNumber == phoneNumber &&
//         other.token == token;
//   }

//   @override
//   int get hashCode {
//     return name.hashCode ^
//         imageUrl.hashCode ^
//         phoneNumber.hashCode ^
//         token.hashCode;
//   }
// }
import 'dart:convert';

class ModelClassForProfileData {
  String? name;
  String? phoneNumber;
  String? imageUrl;
  String? token;

  ModelClassForProfileData({
    this.name,
    this.phoneNumber,
    this.imageUrl,
    this.token,
  });

  ModelClassForProfileData copyWith({
    String? name,
    String? phoneNumber,
    String? imageUrl,
    String? token,
  }) {
    return ModelClassForProfileData(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'token': token,
    };
  }

  factory ModelClassForProfileData.fromMap(Map<String, dynamic> map) {
    return ModelClassForProfileData(
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelClassForProfileData.fromJson(String source) =>
      ModelClassForProfileData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ModelClassForProfileData(name: $name, phoneNumber: $phoneNumber, imageUrl: $imageUrl, token: $token)';
  }
}
