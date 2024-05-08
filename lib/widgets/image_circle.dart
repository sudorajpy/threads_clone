import 'dart:io';

import 'package:flutter/material.dart';
import 'package:threads_clone/utils/helper.dart';

class ImageCircle extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  const ImageCircle({super.key, this.radius = 20, this.url, this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        if (file != null)
          CircleAvatar(
            radius: radius,
            backgroundImage: FileImage(file!),
          )else if (url != null)
          CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(getStorageBucketUrl(url!)),
          )
          else
          CircleAvatar(
                  radius: radius,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
      ],
    );
  }
}
