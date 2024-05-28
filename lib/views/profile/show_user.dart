import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/utils/styles/button_style.dart';
import 'package:threads_clone/views/profile/profile_page.dart';
import 'package:threads_clone/widgets/comment_card.dart';
import 'package:threads_clone/widgets/image_circle.dart';
import 'package:threads_clone/widgets/loading_widget.dart';
import 'package:threads_clone/widgets/post_card.dart';

class ShowUser extends StatefulWidget {
  const ShowUser({super.key});

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  final String userId = Get.arguments;
  
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.showUser(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Icon(Icons.language),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(RouteNames.settings);
              },
              icon: Icon(Icons.sort),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, inerboxSelected) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 160,
                  collapsedHeight: 160,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => profileController.userLoading.value
                            ? LoadingWidget()
                            : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Text(
                                      "${profileController.user.value!.metadata?.name}",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        width: context.width * .7,
                                        child: Text(
                                            "${profileController.user.value!.metadata?.description ?? ''}"))
                                  ],
                                )),
                            ImageCircle(
                              radius: 40,
                              url: profileController.user.value!.metadata?.image,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {
                                  Get.toNamed(RouteNames.chatroom, arguments: {
                                    "targetUserId":userId,
                                    "tagetUserModel" : profileController.user.value
                                  },);
                                },
                                child: Text('Message'),
                              ),
                            ),
                            // SizedBox(
                            //   width: 20,
                            // ),
                            // Expanded(
                            //   child: OutlinedButton(
                            //     style: customOutlineStyle(),
                            //     onPressed: () {},
                            //     child: Text('Share Profile'),
                            //   ),
                            // ),
                          ],
                        )
                        
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            text: "Threads",
                          ),
                          Tab(
                            text: "Replies",
                          ),
                        ],
                      ),
                    ))
              ];
            },
            body: TabBarView(
              children: [
                Obx(
                  () => SingleChildScrollView(
                    // controller: controller,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        if (profileController.postLoading.value)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (profileController.posts.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: profileController.posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PostCardWidget(
                                post: profileController.posts[index],
                              );
                            },
                          )
                        else
                          Text("No Posts found")
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => SingleChildScrollView(
                    // controller: controller,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        if (profileController.replyLoading.value)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (profileController.replies.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: profileController.replies.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CommentCard(
                                reply: profileController.replies[index],
                              );
                            },
                          )
                        else
                          Text("No Replies found")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
