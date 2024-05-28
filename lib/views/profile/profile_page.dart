import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/routes/route.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/styles/button_style.dart';
import 'package:threads_clone/widgets/comment_card.dart';
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
      profileController.fetchPosts(supabaseService.currentUser.value!.id!);
      profileController.fetchReplies(supabaseService.currentUser.value!.id!);
    }
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
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${supabaseService.currentUser.value!.userMetadata?['name']}",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        width: context.width * .7,
                                        child: Text(
                                            "${supabaseService.currentUser.value!.userMetadata?['description'] ?? ''}"))
                                  ],
                                )),
                            ImageCircle(
                              radius: 40,
                              url: supabaseService
                                  .currentUser.value?.userMetadata?['image'],
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
                                  Get.toNamed(RouteNames.editProfile);
                                },
                                child: Text('Edit Profile'),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                style: customOutlineStyle(),
                                onPressed: () {},
                                child: Text('Share Profile'),
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
                Obx(() => SingleChildScrollView(
                  // controller: controller,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      if (profileController.postLoading.value)
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      else if(profileController.posts.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: profileController.posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PostCardWidget(
                            authCard: true,
                            deleteCallBack: profileController.deletePost,
                            post: profileController.posts[index],);
                        },
                      )
                      else
                      Text("No Posts found")
                    ],
                  ),
                ),), 
                Obx(() => SingleChildScrollView(
                  // controller: controller,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      if (profileController.replyLoading.value)
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      else if(profileController.replies.isNotEmpty)
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
                ),)
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
