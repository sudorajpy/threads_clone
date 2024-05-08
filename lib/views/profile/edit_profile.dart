import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/profile_controller.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/widgets/image_circle.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController controller = Get.find<ProfileController>();
  final TextEditingController descriptionController = TextEditingController();
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    if (supabaseService.currentUser.value?.userMetadata?['description'] !=
        null) {
      descriptionController.text =
          supabaseService.currentUser.value?.userMetadata?['description'];
    }
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          Obx(() => TextButton(
              onPressed: () {
                controller.updateProfile(
                    userId: supabaseService.currentUser.value!.id,
                    description: descriptionController.text.trim());
              },
              child:controller.loading.value ? Center(child: CircularProgressIndicator(color: Colors.white,),) : Text('Save')))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ImageCircle(
                      radius: 70,
                      file: controller.image.value,
                      url: supabaseService
                          .currentUser.value?.userMetadata?['image'],
                    ),
                    IconButton(
                        onPressed: () {
                          controller.pickImage();
                        },
                        icon: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white60,
                          child: Icon(Icons.edit),
                        ))
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Your Description',
                label: Text("Description"),
                border: UnderlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
