import 'package:threads_clone/models/user_model.dart';

class FollowingsModel {
  String? userId;
  String? followingId;
  String? createdAt;
  UserModel? user;

  FollowingsModel({this.userId, this.followingId, this.createdAt, this.user});

  FollowingsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    followingId = json['following_id'];
    createdAt = json['created_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['follower_id'] = followingId;
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
