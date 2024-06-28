import 'package:threads_clone/models/user_model.dart';

class FollowersModel {
  String? userId;
  String? followerId;
  String? createdAt;
  UserModel? user;

  FollowersModel({this.userId, this.followerId, this.createdAt, this.user});

  FollowersModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    followerId = json['follower_id'];
    createdAt = json['created_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['follower_id'] = followerId;
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
