import 'package:get/get.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';

class ChatController extends GetxController {
  var userLoading = false.obs;
// Rx<UserModel> user = UserModel().obs;
  RxList<dynamic> messages = [].obs;
  RxInt chatRoomId = 0.obs;

  createChat(String userId, String targetUserId) async {
    List<String> participants = [userId, targetUserId];

    // await SupabaseService.client
    //     .from('chats')
    //     .insert(
    //       {"members": [targetUserId, userId],
    //       "seen_by" : [userId],
    //        "messages": [{
    //       'message' : "hello",
    //       "time" : DateTime.now().toIso8601String(),
    //       "sender" : userId
    //       }]});

    var response = await SupabaseService.client
        .from("chats")
        .select("*")
        // .ilikeAnyOf("members", ["%$userId%", "%$targetUserId%"])
        .contains("members", participants);
    // .inFilter("members", participants);
    // .single();
    print("--------------$response");
    // print(response.runtimeType);
    // print(response[0].runtimeType);
    if (response.isNotEmpty) {
      chatRoomId.value = response[0]['id'];
      messages.value = response[0]['messages'];
    }
  }


  sendMessage(String userId, String targetUserId, String message)async{
        await SupabaseService.client
        .from('chats')
        .insert(
          {"members": [targetUserId, userId],
          "seen_by" : [userId],
           "messages": [{
          'message' : message,
          "time" : DateTime.now().toIso8601String(),
          "sender" : userId
          }]});
  }

// showUser(String userId)async{
//     try {
//       userLoading.value = true;
//       final response = await SupabaseService.client
//           .from('users')
//           .select("*")
//           .eq('id', userId)
//           .single();
//       userLoading.value = false;

//       user.value = UserModel.fromJson(response);

//     } catch (e) {
//       userLoading.value = false;
//       showSnackBar(title: "Error", message: e.toString());
//     }
//   }
}
