import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/services/storage_service.dart';
import 'package:threads_clone/services/supabase_service.dart';
import 'package:threads_clone/utils/helper.dart';
import 'package:threads_clone/utils/storage_keys.dart';

class AuthController extends GetxController {
  var registerLoading = false.obs;
  var loginLoading = false.obs;

// register user
  register({name, email, password}) async {
    registerLoading.value = true;
    try {
      final AuthResponse data = await SupabaseService.client.auth
          .signUp(email: email, password: password, data: {"name": name});

      if (data.user != null) {
        registerLoading.value = false;

        StorageService.session
            .write(StorageKeys.userSession, data.session!.toJson());
        showSnackBar(
          title: "Success",
          message: "User created successfully",
        );

        Get.offAllNamed(RouteNames.home);
      }
    } on AuthException catch (e) {
      print(e);
      registerLoading.value = false;
      showSnackBar(
        title: "Error",
        message: e.message,
      );
    }
  }

  /// login user
  loginUser({email, password}) async {
    loginLoading.value = true;
    try {
      final AuthResponse data = await SupabaseService.client.auth
          .signInWithPassword(email: email, password: password);

      if (data.user != null) {
        loginLoading.value = false;

        StorageService.session
            .write(StorageKeys.userSession, data.session!.toJson());
        showSnackBar(
          title: "Success",
          message: "User created successfully",
        );

        Get.offAllNamed(RouteNames.home);
      }
    } on AuthException catch (e) {
      loginLoading.value = false;
      showSnackBar(
        title: "Error",
        message: e.message,
      );
    }
  }
}
