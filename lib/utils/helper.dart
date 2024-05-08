import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threads_clone/utils/env.dart';
import 'package:threads_clone/widgets/confirm_dialog.dart';
import 'package:uuid/uuid.dart';

void showSnackBar({message, title}) {
  Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      snackStyle: SnackStyle.GROUNDED,
      margin: EdgeInsets.all(0),
      backgroundColor: Color(0xff252526));
}

// * pick image from file

Future<File?> pickImageFromGallery() async {
  const uuid = Uuid();
  final ImagePicker picker = ImagePicker();

  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
  if (file == null) return null;

  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uuid.v6()}.jpg";
  File image = await compressImage(File(file.path), targetPath);
  return image;
}

//* compress image file
Future<File> compressImage(File file, String target) async {
  var result = await FlutterImageCompress.compressAndGetFile(file.path, target,
      quality: 70);
  return File(result!.path);
}

//get storage bucket url
String getStorageBucketUrl(String path) {
  return "${Env.supabaseUrl}/storage/v1/object/public/$path";
}

//confirm dialog
void confirmDialog(String title, String text, VoidCallback callback) {
  Get.dialog(ConfirmDialog(text: text,title: title,callback: callback,));
}
