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
