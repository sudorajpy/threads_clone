import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/utils/helper.dart';

class ShowImage extends StatelessWidget {
  final String image = Get.arguments;
  ShowImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.network(
          getStorageBucketUrl(image),
          fit: BoxFit.contain,
        )
      ),
    );
  }
}
