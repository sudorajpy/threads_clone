import 'dart:convert';

import 'package:get/get.dart';
import 'package:threads_clone/models/notification_model.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';

class NotificationController extends GetxController {
  var loading = false.obs;
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  fetchNotifications(String userId) async {
    try {
      loading.value = true;
      final response =
          await SupabaseService.client.from("notifications").select('''
id, post_id, notification, created_at, user_id, user:user_id (email, metadata)
''').eq("to_user_id", userId).order("id", ascending: false);

      loading.value = false;

      if (response.isNotEmpty) {
        notifications.value =
            response.map((e) => NotificationModel.fromJson(e)).toList();
      }

      print("the notificaton response is ${jsonEncode(response)}");
    } catch (e) {
      loading.value = false;
      showSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }

  // @override
  // void onInit() {

  //   super.onInit();
  // }
}
