import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';

class ReplyController extends GetxController {
  var loading = false.obs;
  RxString reply = ''.obs;
  final TextEditingController replyController = TextEditingController();

  addReply(String userId, int postId, String postUserId) async {
    try {
      loading.value = true;
      // increase the reply count
      await SupabaseService.client
          .rpc("comment_increment", params: {"count": 1, "row_id": postId});

      //add notificatons
      // await SupabaseService.client.from("notifications").insert({
      //   "user_id": userId,
      //   "notification": "Commented on your post",
      //   "to_user_id": postUserId,
      //   "post_id": postId,
      // });
      if (SupabaseService.client.auth.currentUser!.id != userId) {
          await SupabaseService.client.from("notifications").insert({
            "user_id": userId,
            "notification": "Commented on your post",
            "to_user_id": postUserId,
            "post_id": postId,
          });
        }

      // add comment in table
      await SupabaseService.client.from('comments').insert({
        "post_id": postId,
        "user_id": userId,
        "reply": reply.value,
      });

      loading.value = false;
      showSnackBar(
        title: "Success",
        message: "Reply added successfully",
        // snackBarType: SnackBarType.success,
      );
    } catch (e) {
      loading.value = false;
      print(e.toString());
      showSnackBar(
        title: "Error",
        message: e.toString(),
        // snackBarType: SnackBarType.error,
      );
    }
  }

  @override
  void onClose() {
    replyController.dispose();
    super.onClose();
  }
}
