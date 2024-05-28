import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/thread_controller.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/supabase_service.dart';

class PostCardBottomBar extends StatefulWidget {
  final PostModel post;
  const PostCardBottomBar({super.key, required this.post});

  @override
  State<PostCardBottomBar> createState() => _PostCardBottomBarState();
}

class _PostCardBottomBarState extends State<PostCardBottomBar> {
  String likeStatus = "";
  final conntroller = Get.find<ThreadController>();
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  likeDislikePost(String status)async {
    setState(() {
      likeStatus = status;
    });

    await conntroller.likeDislikePost(
      status, 
      widget.post.id!, 
      widget.post.userId!, 
      supabaseService.currentUser.value!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            likeStatus == "1" || widget.post.likes!.any((element) => element.userId == supabaseService.currentUser.value!.id)
            ? IconButton(
                onPressed: () {
                  likeDislikePost("0");
                },
                icon: Icon(Icons.favorite, color: Colors.red[700],))
            : IconButton(
                onPressed: () {
                  likeDislikePost("1");
                }, icon: const Icon(Icons.favorite_outline)),
            IconButton(
                onPressed: () {
                  Get.toNamed(RouteNames.addReply, arguments: widget.post);
                },
                icon: const Icon(Icons.chat_bubble_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send_outlined)),
          ],
        ),
        Row(
          children: [
            Text("${widget.post.likeCount} likes"),
            const SizedBox(
              width: 10,
            ),
            Text("${widget.post.commentCount} replies")
          ],
        ),
      ],
    );
  }
}
