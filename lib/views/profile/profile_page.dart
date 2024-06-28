import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/controllers/show_user_controller.dart';
import 'package:threads_clone/routes/route.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/styles/button_style.dart';
import 'package:threads_clone/widgets/comment_card.dart';
import 'package:threads_clone/widgets/following_header_widget.dart';
import 'package:threads_clone/widgets/image_circle.dart';
import 'package:threads_clone/widgets/post_card.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileController = Get.put(ProfileController());

  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    if (supabaseService.currentUser.value != null) {
      profileController
          .getFollowersFollowings(supabaseService.currentUser.value!.id!);
      profileController.fetchPosts(supabaseService.currentUser.value!.id!);
      profileController.fetchReplies(supabaseService.currentUser.value!.id!);
    }
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
                            ImageCircle(
                              radius: 40,
                              url: supabaseService
                                  .currentUser.value?.userMetadata?['image'],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            FollowingHeaderWidget(
                              isCurrentUser: true,
                              showUserController: ShowUserController(),
                                profileController: profileController)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${supabaseService.currentUser.value!.userMetadata?['name']}",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        width: context.width * .7,
                                        child: Text(
                                            "${supabaseService.currentUser.value!.userMetadata?['description'] ?? ''}"))
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {
                                  Get.toNamed(RouteNames.editProfile);
                                },
                                child: const Text('Edit Profile'),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {},
                                child: const Text('Share Profile'),
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
                                authCard: true,
                                deleteCallBack: profileController.deletePost,
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

// * sliver peristent header delegate

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  SliverAppBarDelegate(this._tabBar);

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
