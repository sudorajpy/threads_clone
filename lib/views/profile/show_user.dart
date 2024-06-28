import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/controllers/show_user_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/styles/button_style.dart';
import 'package:threads_clone/views/profile/profile_page.dart';
import 'package:threads_clone/widgets/comment_card.dart';
import 'package:threads_clone/widgets/following_header_widget.dart';
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

  final profileController = Get.put(ShowUserController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    profileController.showUser(userId);
    profileController.checkFollowing(
        supabaseService.currentUser.value!.id, userId);
    profileController.getFollowersFollowings(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Icon(Icons.language),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(RouteNames.settings);
              },
              icon: const Icon(Icons.sort),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, inerboxSelected) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 220,
                  collapsedHeight: 220,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              ()=> ImageCircle(
                                radius: 40,
                                url:
                                    profileController.user.value!.metadata?.image,
                              ),
                            ),
                            FollowingHeaderWidget(
                                isCurrentUser: false,
                                showUserController: profileController,
                                profileController: ProfileController())
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => profileController.userLoading.value
                                ? const LoadingWidget()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${profileController.user.value!.metadata?.name}",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                          width: context.width * .7,
                                          child: Text(
                                              "${profileController.user.value!.metadata?.description ?? ''}"))
                                    ],
                                  )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Expanded(
                                child: OutlinedButton(
                                  style: customOutlineStyle(),
                                  onPressed: () {
                                    if (profileController.isFollowing.value) {
                                      profileController.unFollowUser(
                                          supabaseService.currentUser.value!.id,
                                          userId);
                                    } else {
                                      profileController.followUser(
                                          supabaseService.currentUser.value!.id,
                                          userId);
                                    }
                                  },
                                  child: Text(
                                      profileController.isFollowing.value
                                          ? "Following"
                                          : 'Follow'),
                                ),
                              ),
                            ),
                            // ignore: prefer_const_constructors
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {
                                  profileController.checkFollowing(
                                      supabaseService.currentUser.value!.id,
                                      userId);
                                },
                                child: Text('Message'),
                              ),
                            ),
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
                      const TabBar(
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
                        const SizedBox(
                          height: 10,
                        ),
                        if (profileController.postLoading.value)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (profileController.posts.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: profileController.posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PostCardWidget(
                                post: profileController.posts[index],
                              );
                            },
                          )
                        else
                          const Text("No Posts found")
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => SingleChildScrollView(
                    // controller: controller,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        if (profileController.replyLoading.value)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (profileController.replies.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: profileController.replies.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CommentCard(
                                reply: profileController.replies[index],
                              );
                            },
                          )
                        else
                          const Text("No Replies found")
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
