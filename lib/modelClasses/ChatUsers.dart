// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatUser {
  String name;
  String imageUrl;
  String phoneNumber;
  ChatUser({
    required this.name,
    required this.imageUrl,
    required this.phoneNumber,
  });

  ChatUser copyWith({
    String? name,
    String? imageUrl,
    String? phoneNumber,
  }) {
    return ChatUser(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatUser(name: $name, imageUrl: $imageUrl, phoneNumber: $phoneNumber)';

  @override
  bool operator ==(covariant ChatUser other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.imageUrl == imageUrl &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode ^ phoneNumber.hashCode;
}
