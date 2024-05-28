import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/home_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/widgets/loading_widget.dart';
import 'package:threads_clone/widgets/post_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () => controller.fetchThreads(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                        height: 50,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteNames.chatroom);
                          },
                          child: Icon(Icons.message))
                    ],
                  ),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () => controller.loading.value
                      ? LoadingWidget()
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PostCardWidget(
                              post: controller.posts[index],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
