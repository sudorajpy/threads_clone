import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:threads_clone/controllers/reply_controller.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/widgets/image_circle.dart';
import 'package:threads_clone/widgets/post_card_image.dart';

class Addreply extends StatelessWidget {
  Addreply({super.key});

  final PostModel post = Get.arguments;
  final ReplyController controller = Get.put(ReplyController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reply'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          Obx(
            () => TextButton(
                onPressed: () {
                  if (controller.reply.value.isNotEmpty) {
                    controller.addReply(supabaseService.currentUser.value!.id,
                        post.id!, post.userId!);
                    // Get.back();
                  }
                },
                child: controller.loading.value
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text("Reply")),
          )
        ],
      ),
      body: SingleChildScrollView(
        // controller: controller,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: context.width * .12,
                    child: ImageCircle(
                      url: post.user?.metadata?.image,
                    )),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: context.width * .8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user!.metadata!.name!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(post.content!),
                      SizedBox(
                        height: 10,
                      ),
                      if (post.image != null) PostCardImage(url: post.image!),

                      // rply field
                      TextField(
                        autofocus: true,
                        controller: controller.replyController,
                        onChanged: (value) => controller.reply.value = value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLength: 1000,
                        maxLines: 10,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Type a reply...',
                          border: InputBorder.none,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
