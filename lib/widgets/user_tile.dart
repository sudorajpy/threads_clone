import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/utils/styles/button_style.dart';
import 'package:threads_clone/widgets/image_circle.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(top: 5),
        child: ImageCircle(
          url: user.metadata?.image,
        ),
      ),
      title: Text(user.metadata!.name!),
      titleAlignment: ListTileTitleAlignment.top,
      trailing: OutlinedButton(
          onPressed: () {
            Get.toNamed(RouteNames.showUser, arguments: user.id);
          },
          style: customOutlineStyle(),
          child: Text("View Profile")),
    );
  }
}
