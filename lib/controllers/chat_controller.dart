import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';

class ChatController extends GetxController {
  var userLoading = false.obs;
// Rx<UserModel> user = UserModel().obs;
  RxList<dynamic> messages = [].obs;
  RxInt chatRoomId = 0.obs;
  String chatDocId = "";
  var msgController = TextEditingController();
  var msgLoading = false.obs;
  StreamSubscription? _chatSubscription;

  checkChatRoom(String userId, String targetUserId) async {
    List<String> participants = [userId, targetUserId];
    chatDocId = getChatRoomId(userId, targetUserId);

    SupabaseService.client
        .from('chats')
        .select()
        .eq('chat_id', chatDocId)
        .then((value) async {
      if (value != null && value.isNotEmpty) {
        print(value[0]);
        messages.value = value[0]['messages'];
      } else {
        // createChatRoom(userId, targetUserId);
        await SupabaseService.client.from('chats').insert({
          "chat_id": chatDocId,
          "members": [targetUserId, userId],
          "seen_by": [userId],
          "messages": []
        });
      }
    });

    // var response = await SupabaseService.client
    //     .from("chats")
    //     .select("*")
    //     .contains("members", participants);
    // if (response.isNotEmpty) {
    //   print(jsonEncode(response[0]));
    //   chatRoomId.value = response[0]['id'];
    //   messages.value = response[0]['messages'];
    // } else {
    //   await SupabaseService.client.from('chats').insert({
    //     "members": [targetUserId, userId],
    //     "seen_by": [userId],
    //     "messages": [{}]
    //   }).then((value) {
    //     chatRoomId.value = value.data[0]['id'];
    //   });
    // }
  }

  sendMessage(String userId, String targetUserId, String message) async {
    Map<String, dynamic> newMessage = {
      'message': message,
      "time": DateTime.now().toIso8601String(),
      "sender": userId
    };

    await SupabaseService.client.rpc("add_message",
        params: {"chat_idd": chatDocId, "new_message": newMessage});
    msgController.clear();
  }

  updateSeenBy(String userId) async {
    await SupabaseService.client.from('chats').update({
      "seen_by": [userId]
    }).eq('id', chatRoomId.value);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _chatSubscription = SupabaseService.client
        .from('chats')
        .stream(primaryKey: ['chat_id'])
        .eq('chat_id', chatDocId)
        .listen(
          (data) {
            print('i am listening');
            messages.value = data[0]["messages"];
          },
        );
    super.onInit();
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }
}
