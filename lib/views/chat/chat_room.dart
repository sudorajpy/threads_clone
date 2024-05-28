import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/chat_controller.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/widgets/image_circle.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({super.key});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var controller = Get.put(ChatController());
  var targetUserModel = UserModel();
  var argData = Get.arguments;
  var msgController = TextEditingController();
  // final UserModel targetUserModel = Get.arguments;
  @override
  void initState() {
    // print(argData['targetUserId']);
    targetUserModel = argData['tagetUserModel'];
    controller.createChat(
        SupabaseService.client.auth.currentUser!.id, argData['targetUserId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ImageCircle(
                url: targetUserModel.metadata?.image,
              ),
              SizedBox(
                width: 20,
              ),
              Text(targetUserModel.metadata!.name!)
            ],
          ),
        ),
        body: Obx(
          () => Column(
            children: [
              if (controller.messages.isEmpty)
                Text("No Chats Availble please message")
              else
                StreamBuilder(
                  stream: SupabaseService.client.from('countries').stream(
                      primaryKey: ['id']).eq('id', controller.chatRoomId.value),
                  // initialData: initialData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print('object');
                    print(snapshot.data);
                    return Container(
                      // child: child,
                      color: Colors.green,
                    );
                  },
                ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: msgController,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          controller.sendMessage(
                              SupabaseService.client.auth.currentUser!.id,
                              argData['targetUserId'],
                              msgController.text);
                        },
                        child: Icon(Icons.send))),
              )
            ],
          ),
        )
        // StreamBuilder(
        //   stream: SupabaseService.client.from('chats').stream(primaryKey: ['id']).contains(
        //     "members" : [argData['targetUserId'], SupabaseService.client.auth.!currentUser.id]
        //   ).,
        //   // initialData: initialData,
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     return Container(
        //       child: child,
        //     );
        //   },
        // ),,
        );
  }
}
