import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/utils/styles/button_style.dart';
import 'package:threads_clone/widgets/image_circle.dart';

class FollowersListScreen extends StatelessWidget {
  FollowersListScreen({super.key});

  final int index = Get.arguments;

  var profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Followers"),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: index,
        // child: TabBar(tabs: [Tab(text: "Followers"), Tab(text: "Following")]),
        child: Builder(builder: (context) {
          return Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: "Followers"),
                  Tab(text: "Following"),
                ],
              ),
              Expanded(
                child: Obx(
                  ()=> TabBarView(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: profileController.followersList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            isThreeLine: true,
                            leading: ImageCircle(
                                radius: 25,
                                url: profileController
                                    .followersList[index].user?.metadata?.image),
                            title: Text(
                                "${profileController.followersList[index].user?.metadata?.name}"),
                            // titleAlignment: ListTileTitleAlignment.top,
                            subtitle: Text(
                                "${profileController.followersList[index].user?.metadata?.username ?? "---"}"),
                            trailing: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {
                                  // print(profileController
                                  //     .followersList[index].user?.id);
                                  Get.toNamed(RouteNames.showUser,
                                      arguments: profileController
                                          .followersList[index].user?.id);
                                },
                                child: const Text("Profile")),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: profileController.followingsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            isThreeLine: true,
                            leading: ImageCircle(
                                radius: 25,
                                url: profileController
                                    .followingsList[index].user?.metadata?.image),
                            title: Text(
                                "${profileController.followingsList[index].user?.metadata?.name}"),
                            // titleAlignment: ListTileTitleAlignment.top,
                            subtitle: Text(
                                "${profileController.followingsList[index].user?.metadata?.username ?? "---"}"),
                            trailing: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {
                                  // print(profileController
                                  //     .followersList[index].user?.id);
                                  Get.toNamed(RouteNames.showUser,
                                      arguments: profileController
                                          .followingsList[index].user?.id);
                                },
                                child: const Text("Profile")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
