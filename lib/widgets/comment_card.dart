// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/models/reply_model.dart';
import 'package:threads_clone/widgets/comment_topbar.dart';
import 'package:threads_clone/widgets/image_circle.dart';

class CommentCard extends StatelessWidget {
  final ReplyModel reply;
  const CommentCard({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: context.width * 0.12,
              child: ImageCircle(
                url: reply.user?.metadata?.image,
              ),
            ),
            SizedBox(width: 10,),
            SizedBox(
              width: context.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentTopBar(reply: reply),
                  Text(reply.reply!),
                ],
              ),
            )
          ],
        ),
        const Divider(
          color: Color(0xff242424),
        )
      ],
    );
  }
}
