import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/navigation_service.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';
import 'package:threads_clone/utils/type_def.dart';
import 'package:threads_clone/widgets/image_circle.dart';
import 'package:threads_clone/widgets/post_card_bottombar.dart';
import 'package:threads_clone/widgets/post_card_image.dart';
import 'package:threads_clone/widgets/post_topbar.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final bool authCard;
  final DeleteCallBack? deleteCallBack;
  PostCardWidget(
      {super.key,
      this.authCard = false,
      required this.post,
      this.deleteCallBack});

  var navigatiionService = Get.find<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (SupabaseService.client.auth.currentUser!.id ==
                      post.userId) {
                    navigatiionService.updateIndex(4);
                  } else {
                    Get.toNamed(RouteNames.showUser, arguments: post.userId);
                  }
                },
                child: SizedBox(
                  width: context.width * .12,
                  child: ImageCircle(
                    url: post.user?.metadata?.image,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: context.width * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostTopBar(
                      post: post,
                      authCard: authCard,
                      deleteCallBack: deleteCallBack,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.showThread,
                              arguments: post.id);
                        },
                        child: Text(post.content!)),
                    const SizedBox(
                      height: 10,
                    ),
                    if (post.image != null)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.showImage,
                              arguments: post.image);
                        },
                        child: PostCardImage(
                          url: post.image!,
                        ),
                      ),
                    PostCardBottomBar(
                      post: post,
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Color(0xff242424),
          ),
        ],
      ),
    );
  }
}
