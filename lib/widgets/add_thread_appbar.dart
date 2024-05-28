import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/thread_controller.dart';
import 'package:threads_clone/services/navigation_service.dart';
import 'package:threads_clone/services/supabase_service.dart';

class AddThreadAppBar extends StatelessWidget {
  
  AddThreadAppBar({
    super.key,
  });

  final ThreadController threadController = Get.find<ThreadController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.find<NavigationService>().backToPreviousPage();
                },
                icon: Icon(Icons.close),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Threads',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Obx(
            ()=> TextButton(
              onPressed: () {
                if (threadController.content.value.isNotEmpty) {
                  threadController.store(Get.find<SupabaseService>().currentUser.value!.id);
                }else{
                  Get.snackbar('Error', 'Content cannot be empty');
                }
              },
              child:threadController.loading.value 
              ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator.adaptive(),
              ) 
              : Text(
                'Post',
                style: TextStyle(fontSize: 16, fontWeight: threadController.content.value.isNotEmpty ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
