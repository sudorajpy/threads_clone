import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/models/reply_model.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/env.dart';
import 'package:threads_clone/utils/helper.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  var postLoading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  var replyLoading = false.obs;
  RxList<ReplyModel> replies = RxList<ReplyModel>();

  Rx<File?> image = Rx<File?>(null);
  var userLoading = false.obs;
  Rx<UserModel> user = UserModel().obs;

  //* update profile
  updateProfile({
    userId,
    description,
  }) async {
    try {
      loading.value = true;
      var uploadedPath = '';
      if (image.value != null && image.value!.existsSync()) {
        final String dir = "$userId/profile.jpg";
        var path = await SupabaseService.client.storage
            .from(Env.storageBucket)
            .upload(dir, image.value!, fileOptions: FileOptions(upsert: true));

        uploadedPath = path;
      }

      //* update profile
      await SupabaseService.client.auth.updateUser(UserAttributes(data: {
        "description": description,
        "image": uploadedPath.isNotEmpty ? uploadedPath : null
      }));
      loading.value = false;
      Get.back();
      showSnackBar(title: "Success", message: "Profile updated successfully");
    } on StorageException catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.message);
    } on AuthException catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.message);
    } catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }

  //* pick image
  void pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) {
      image.value = file;
      print(true);
    }
  }

// fetch posts
  fetchPosts(String userId) async {
    try {
      postLoading.value = true;
      final List<dynamic> response =
          await SupabaseService.client.from('posts').select('''
id,content,image,created_at,comment_count, like_count, user_id,
user:user_id (email, metadata), likes:likes (user_id, post_id)
''').eq("user_id", userId).order("id", ascending: false);
      postLoading.value = false;
      if (response.isNotEmpty) {
        posts.value = response.map((e) => PostModel.fromJson(e)).toList();
      }
    } catch (e) {
      postLoading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }

//fetch replies
  fetchReplies(String userId) async {
    try {
      replyLoading.value = true;
      final List<dynamic> response =
          await SupabaseService.client.from('comments').select('''
  user_id, post_id, reply, created_at, user:user_id (email, metadata)
  ''').eq("user_id", userId).order("id", ascending: false);
      // print("the replies are ${json.encode(response)}");
      replyLoading.value = false;
      if (response.isNotEmpty) {
        replies.value = response.map((e) => ReplyModel.fromJson(e)).toList();
      }
    } catch (e) {
      replyLoading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }

  //show user
  showUser(String userId)async{
    try {
      userLoading.value = true;
      final response = await SupabaseService.client
          .from('users')
          .select("*")
          .eq('id', userId)
          .single();
      userLoading.value = false;

      user.value = UserModel.fromJson(response);

      fetchPosts(userId);
      fetchReplies(userId);
    } catch (e) {
      userLoading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }



  //* delete post
  deletePost(int postId) async {
    try {
      await SupabaseService.client.from('posts').delete().eq('id', postId);
      posts.removeWhere((element) => element.id == postId);
      if (Get.isDialogOpen!) {
        Get.back();
      }
      showSnackBar(title: "Success", message: "Post deleted successfully");
    } catch (e) {
      showSnackBar(title: "Error", message: e.toString());
    }
  }
}
