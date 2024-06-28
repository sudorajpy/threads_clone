class UserModel {
  String? email;
  String? id;
  Metadata? metadata;

  UserModel({this.email, this.metadata, this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['id'] = id;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  String? sub;
  String? name;
  String? email;
  String? image;
  var username;
  String? description;
  bool? emailVerified;
  bool? phoneVerified;

  Metadata(
      {this.sub,
      this.name,
      this.username,
      this.email,
      this.image,
      this.description,
      this.emailVerified,
      this.phoneVerified});

  Metadata.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    username = json['username'];
    description = json['description'];
    emailVerified = json['email_verified'];
    phoneVerified = json['phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub'] = sub;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['username'] = username;
    data['description'] = description;
    data['email_verified'] = emailVerified;
    data['phone_verified'] = phoneVerified;
    return data;
  }
}
