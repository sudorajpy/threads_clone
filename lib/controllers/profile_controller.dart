import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/env.dart';
import 'package:threads_clone/utils/helper.dart';

class ProfileController extends GetxController {
  var loading = false.obs;

  Rx<File?> image = Rx<File?>(null);

  //* update profile
  updateProfile({
    userId,
    description,
  }) async {
    try {
      loading.value = true;
      var uploadedPath = '';
      if (image.value != null && image.value!.existsSync()) {
        final String dir = "$userId/profile.jpg";
        var path = await SupabaseService.client.storage
            .from(Env.storageBucket)
            .upload(dir, image.value!, fileOptions: FileOptions(upsert: true));

        uploadedPath = path;
      }

      //* update profile
      await SupabaseService.client.auth.updateUser(UserAttributes(data: {
        "description": description,
        "image": uploadedPath.isNotEmpty ? uploadedPath : null
      }));
      loading.value = false;
      Get.back();
      showSnackBar(title: "Success", message: "Profile updated successfully");
    } on StorageException catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.message);
    } on AuthException catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.message);
    } catch (e) {
      loading.value = false;
      showSnackBar(title: "Error", message: e.toString());
    }
  }

  //* pick image
  void pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) {
      image.value = file;
      print(true);
    }
  }
}
