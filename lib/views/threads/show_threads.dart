import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/thread_controller.dart';
import 'package:threads_clone/widgets/comment_card.dart';
import 'package:threads_clone/widgets/loading_widget.dart';
import 'package:threads_clone/widgets/post_card.dart';

class ShowThreads extends StatefulWidget {
  const ShowThreads({super.key});

  @override
  State<ShowThreads> createState() => _ShowThreadsState();
}

class _ShowThreadsState extends State<ShowThreads> {
  final int postId = Get.arguments;
  final controller = Get.put(ThreadController());

  @override
  void initState() {
    controller.show(postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Threads'),
      ),
      body: Obx(
        () => controller.showThreadLoading.value
            ? LoadingWidget()
            : SingleChildScrollView(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    PostCardWidget(post: controller.thread.value,),
                    SizedBox(height: 20,),
                    if(controller.showCommentsLoading.value)
                    LoadingWidget()
                    else if(controller.comments.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.comments.length,
                      itemBuilder: (context, index) {
                        return CommentCard(reply: controller.comments[index]);
                      },
                    )
                    else
                    const Center(child: Text('No comments found'),),
                  ],
                ),
              ),
      ),
    );
  }
}
