import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/controllers/show_user_controller.dart';
import 'package:threads_clone/routes/route_name.dart';

class FollowingHeaderWidget extends StatelessWidget {
  const FollowingHeaderWidget({
    super.key,
    required this.profileController,
    required this.showUserController,
    required this.isCurrentUser,
  });

  final ProfileController profileController;
  final bool isCurrentUser;
  final ShowUserController showUserController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          GestureDetector(
            onTap: () {
              if (isCurrentUser) {
                profileController
                    .getFollowersList(profileController.user.value.id!);
                profileController
                    .getFollowingsList(profileController.user.value.id!);
                Get.toNamed(RouteNames.followersList, arguments: 0);
              } else {
                showUserController
                    .getFollowersList(showUserController.user.value.id!);
                showUserController
                    .getFollowingsList(showUserController.user.value.id!);
                Get.toNamed(RouteNames.followersList, arguments: 0);
              }
            },
            child: Column(
              children: [
                Text(
                  "${isCurrentUser ? profileController.followers.value : showUserController.followers.value}",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Followers",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              if (isCurrentUser) {
                profileController
                    .getFollowersList(profileController.user.value.id!);
                profileController
                    .getFollowingsList(profileController.user.value.id!);
                Get.toNamed(RouteNames.followersList, arguments: 1);
              } else {
                showUserController
                    .getFollowersList(showUserController.user.value.id!);
                showUserController
                    .getFollowingsList(showUserController.user.value.id!);
                Get.toNamed(RouteNames.followersList, arguments: 1);
              }
            },
            child: Column(
              children: [
                Text(
                  "${isCurrentUser ? profileController.followings.value : showUserController.followings.value}",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Following",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
