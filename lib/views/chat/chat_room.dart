import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/chat_controller.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/widgets/image_circle.dart';
import 'package:threads_clone/widgets/loading_widget.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({super.key});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var controller = Get.put(ChatController());
  var targetUserModel = UserModel();
  var argData = Get.arguments;

  // var msgController = TextEditingController();
  // final UserModel targetUserModel = Get.arguments;
  @override
  void initState() {
    // print(argData['targetUserId']);
    targetUserModel = argData['tagetUserModel'];
    controller.checkChatRoom(
        SupabaseService.client.auth.currentUser!.id, argData['targetUserId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            ImageCircle(
              url: targetUserModel.metadata?.image,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(targetUserModel.metadata!.name!)
          ],
        ),
      ),
      body:
          //  Obx( () => controller.msgLoading.value
          //       ? const LoadingWidget()
          //       :
          Column(
        children: [
          // if (controller.messages.isEmpty)
          //   const Text("No Chats Availble please message")
          // else
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                // reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isMe = controller.messages[index]['sender'] ==
                      SupabaseService.client.auth.currentUser!.id;
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      // color: Colors.red,
                      // color: isSenderIsMe ?  Colors.purple : Colors.blue,
                      child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              ImageCircle(
                                url: targetUserModel.metadata?.image,
                              ),
                            if (!isMe)
                              const SizedBox(
                                width: 10,
                              ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              // width: context.width * 0.5,
                              decoration: BoxDecoration(
                                  color: isMe ? Colors.blue : Color(0xff242424),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Text(
                                    controller.messages[index]['message'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ]));
                },
              ),
            ),
            // StreamBuilder(
            //   stream: SupabaseService.client
            //       .from('chats')
            //       .stream(primaryKey: ['chat_id']).eq(
            //           'chat_id', controller.chatDocId),
            //   builder:
            //       (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.connectionState ==
            //         ConnectionState.waiting) {
            //       return const LoadingWidget();
            //     }
            //     if (snapshot.data == null) {
            //       return const Center(
            //         child: Text("No Messages"),
            //       );
            //     }
            //     var msg = snapshot.data[0]["messages"];
            //     controller.updateSeenBy(
            //         SupabaseService.client.auth.currentUser!.id);

            //     return SizedBox(
            //       height: 500,
            //       child: ListView.builder(
            //         shrinkWrap: true,
            //         // reverse: true,
            //         itemCount: msg.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           bool isMe = msg[index]['sender'] ==
            //               SupabaseService
            //                   .client.auth.currentUser!.id;
            //           return Container(
            //               margin: const EdgeInsets.symmetric(
            //                   vertical: 0),
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 20, vertical: 8),
            //               // color: Colors.red,
            //               // color: isSenderIsMe ?  Colors.purple : Colors.blue,
            //               child: Row(
            //                   mainAxisAlignment: isMe
            //                       ? MainAxisAlignment.end
            //                       : MainAxisAlignment.start,
            //                   crossAxisAlignment:
            //                       CrossAxisAlignment.start,
            //                   children: [
            //                     if (!isMe)
            //                       ImageCircle(
            //                         url: targetUserModel
            //                             .metadata?.image,
            //                       ),
            //                     if (!isMe)
            //                       const SizedBox(
            //                         width: 10,
            //                       ),
            //                     Container(
            //                       padding: const EdgeInsets.all(10),
            //                       // width: context.width * 0.5,
            //                       decoration: BoxDecoration(
            //                           color: isMe
            //                               ? Colors.blue
            //                               : Color(0xff242424),
            //                           borderRadius:
            //                               BorderRadius.circular(
            //                                   10)),
            //                       child: Column(
            //                         children: [
            //                           Text(
            //                             msg[index]['message'],
            //                             style: const TextStyle(
            //                                 color: Colors.white),
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   ]));
            //         },
            //       ),
            //     );
            //   },
            // ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          Container(
            height: 50,
            width: context.width * 0.9,
            child: TextField(
              controller: controller.msgController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        controller.sendMessage(
                            SupabaseService.client.auth.currentUser!.id,
                            argData['targetUserId'],
                            controller.msgController.text);
                      },
                      child: const Icon(Icons.send))),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
      // )
    );
  }
}
