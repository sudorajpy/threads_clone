import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/utils/helper.dart';

// import 'package:flutter/material.dart';

class PostCardImage extends StatelessWidget {
  final String url;
  const PostCardImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: context.height * .6, maxWidth: context.width * .8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          getStorageBucketUrl(url),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
