import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/notification_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';
import 'package:threads_clone/widgets/image_circle.dart';
import 'package:threads_clone/widgets/loading_widget.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    controller
        .fetchNotifications(Get.find<SupabaseService>().currentUser.value!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Obx(
          () => controller.loading.value
              ? LoadingWidget()
              : Column(
                  children: [
                    if (controller.notifications.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              onTap: () {
                                Get.toNamed(RouteNames.showThread,
                                    arguments:
                                        controller.notifications[index].postId);
                              },
                              leading: ImageCircle(
                                url: controller
                                    .notifications[index].user?.metadata?.image,
                              ),
                              title: Text(controller
                                  .notifications[index].user!.metadata!.name!),
                              trailing: Text(formateDateFromNow(
                                  controller.notifications[index].createdAt!)),
                              subtitle: Text(controller
                                  .notifications[index].notification!));
                        },
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
