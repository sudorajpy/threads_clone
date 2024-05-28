import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:threads_clone/models/reply_model.dart';
import 'package:threads_clone/utils/helper.dart';

class CommentTopBar extends StatelessWidget {
  final ReplyModel reply;
  const CommentTopBar({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          reply.user!.metadata!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Text(formateDateFromNow(reply.createdAt!)),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.more_horiz)
          ],
        )
      ],
    );
  }
}
