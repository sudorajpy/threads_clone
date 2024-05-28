import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:threads_clone/controllers/thread_controller.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/widgets/add_thread_appbar.dart';
import 'package:threads_clone/widgets/image_circle.dart';

class AddThreadsPage extends StatelessWidget {
  AddThreadsPage({super.key});

  final SupabaseService supabaseService = Get.find<SupabaseService>();
  final ThreadController threadController = Get.put(ThreadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // controller: controller,
          child: Column(
            children: [
              AddThreadAppBar(),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => ImageCircle(
                      url: supabaseService
                          .currentUser.value!.userMetadata?['image'],
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: context.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(()=> Text("${supabaseService.currentUser.value!.userMetadata?['name']}"),),
                        TextField(
                          autofocus: true,
                          controller: threadController.textController,
                          onChanged: (value) => threadController.content.value = value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLength: 1000,
                          maxLines: 10,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'What\'s on your mind?',
                            border: InputBorder.none,
                           
                          ),
                        ),
                        GestureDetector(
                          onTap: () => threadController.pickImage(),
                          child: Icon(Icons.attach_file),),

                          SizedBox(height: 10,),

                          // to preview selected image
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Obx(
                                    () => threadController.image.value != null
                                        ? Image.file(
                                            threadController.image.value!,
                                            width: context.width * 0.8,
                                            height: context.height * 0.3,
                                            fit: BoxFit.cover,
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => threadController.image.value = null,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
