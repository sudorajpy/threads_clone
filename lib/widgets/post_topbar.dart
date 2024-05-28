import 'package:flutter/material.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/utils/helper.dart';
import 'package:threads_clone/utils/type_def.dart';
// import 'package:flutter/widgets.dart';

class PostTopBar extends StatelessWidget {
  final PostModel post;
  final bool authCard;
  final DeleteCallBack? deleteCallBack;
  const PostTopBar(
      {super.key,
      required this.post,
      this.authCard = false,
      this.deleteCallBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          post.user!.metadata!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Text(formateDateFromNow(post.createdAt!)),
            SizedBox(
              width: 10,
            ),
            authCard
                ? GestureDetector(
                    onTap: () {
                      confirmDialog("Are you sure?", "You want to delete post",
                          () {
                        deleteCallBack!(post.id!);
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
                : Icon(Icons.more_horiz)
          ],
        )
      ],
    );
  }
}
