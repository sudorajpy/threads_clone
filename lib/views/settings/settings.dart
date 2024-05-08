import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/setting_controller.dart';
import 'package:threads_clone/utils/helper.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  var controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                confirmDialog(
                  "Are you sure?",
                  "Do you want to logout?",
                  controller.logout,
                );
              },
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              trailing: Icon(Icons.arrow_forward_ios),
            )
          ],
        ),
      ),
    );
  }
}
