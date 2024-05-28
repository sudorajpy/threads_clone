import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/models/reply_model.dart';
import 'package:threads_clone/services/navigation_service.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/env.dart';
import 'package:threads_clone/utils/helper.dart';
import 'package:uuid/uuid.dart';

class ThreadController extends GetxController {
  final TextEditingController textController = TextEditingController(text: '');
  RxString content = ''.obs;
  RxBool loading = false.obs;
  Rx<File?> image = Rx<File?>(null);

  var showThreadLoading = false.obs;
  Rx<PostModel> thread = Rx<PostModel>(PostModel());

  var showCommentsLoading = false.obs;
  RxList<ReplyModel> comments = RxList<ReplyModel>();

  pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) {
      image.value = file;
    }
  }

//show post/thread
  show(int postId) async {
    try {
      thread.value = PostModel();
      comments.value = [];
      showThreadLoading.value = true;

      final response = await SupabaseService.client.from('posts').select('''
id,content,image,created_at,comment_count, like_count, user_id,
user:user_id (email, metadata), likes:likes (user_id, post_id)
''').eq('id', postId).single();

      showThreadLoading.value = false;
      thread.value = PostModel.fromJson(response);
      //fetch comments
      fetchPostComments(postId);
    } catch (e) {
      showThreadLoading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }

  //fetch post comments
  fetchPostComments(int postId) async {
    try {
      showCommentsLoading.value = true;
      final List<dynamic> response =
          await SupabaseService.client.from('comments').select('''
  user_id, post_id, reply, created_at, user:user_id (email, metadata)
  ''').eq("post_id", postId);
      showCommentsLoading.value = false;
      if (response.isNotEmpty) {
        comments.value = response.map((e) => ReplyModel.fromJson(e)).toList();
      }
    } catch (e) {
      showCommentsLoading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }

  //post thread
  store(String userID) async {
    try {
      loading.value = true;
      const uuid = Uuid();
      final dir = "$userID/${uuid.v6()}";
      var imagePath = '';
      if (image.value != null && image.value!.existsSync()) {
        imagePath = await SupabaseService.client.storage
            .from(Env.storageBucket)
            .upload(dir, image.value!);
      }
      // add post to the database
      await SupabaseService.client.from('posts').insert({
        "user_id": userID,
        "content": content.value,
        "image": imagePath.isNotEmpty ? imagePath : null,
      });
      loading.value = false;
      content.value = '';
      textController.clear();
      image.value = null;
      Get.find<NavigationService>().currentIndex.value = 0;
      showSnackBar(title: "Success", message: "Thread added successfully");
    } on StorageException catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.message);
    } catch (e) {
      loading.value = false;
      showSnackBar(
          title: "Error", message: "SOmething went wrong, try again later");
    }
  }

// like or dislike post
  likeDislikePost(
      String status, int postId, String postUserId, String userId) async {
    //check if the user has already liked the post
    try {
      var user = await SupabaseService.client
          .from('likes')
          .select("*")
          .match({"post_id": postId, "user_id": userId});
      // print("the response is ${jsonEncode(user)}");

      if (user.isEmpty) {
        await SupabaseService.client.from('likes').insert({
          "post_id": postId,
          "user_id": userId,
        });

        //add liike notification
        if (SupabaseService.client.auth.currentUser!.id != userId) {
          await SupabaseService.client.from("notifications").insert({
            "user_id": userId,
            "notification": "Liked on your post",
            "to_user_id": postUserId,
            "post_id": postId,
          });
        }

        // increment the like count
        await SupabaseService.client
            .rpc("like_increment", params: {"count": 1, "row_id": postId});
      } else {
        //delete like entry
        await SupabaseService.client.from('likes').delete().match({
          "post_id": postId,
          "user_id": userId,
        });

        //delete like notification

        // decrement the like count
        await SupabaseService.client
            .rpc("like_decrement", params: {"count": 1, "row_id": postId});
      }
    } catch (e) {
      showSnackBar(
        title: "error",
        message: e.toString(),
      );
      print(e);
    }

    // if (status == '1') {
    // await SupabaseService.client.from('likes').insert({
    //   "post_id": postId,
    //   "user_id": userId,
    // });

    // //add liike notification
    // await SupabaseService.client.from("notifications").insert({
    //   "user_id": userId,
    //   "notification": "Liked on your post",
    //   "to_user_id": postUserId,
    //   "post_id": postId,
    // });

    // // increment the like count
    // await SupabaseService.client
    //     .rpc("like_increment", params: {"count": 1, "row_id": postId});
    // } else {
    // //delete like entry
    // await SupabaseService.client.from('likes').delete().match({
    //   "post_id": postId,
    //   "user_id": userId,
    // });

    // //delete like notification

    // // decrement the like count
    // await SupabaseService.client
    //     .rpc("like_decrement", params: {"count": 1, "row_id": postId});
    // }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
