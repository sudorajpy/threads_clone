import 'dart:async';

import 'package:get/get.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/services/supabase_service.dart';

class SearchUserController extends GetxController {
  var loading = false.obs;
  var notFound = false.obs;
  RxList<UserModel> users = <UserModel>[].obs;
  Timer? _debounce; 

  searchUser(String name) async {
    loading.value = true;
    notFound.value = false;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (name.isNotEmpty) {
        final List<dynamic> data = await SupabaseService.client
            .from('users')
            .select("*")
            .ilike("metadata ->> name", "%$name%");
        loading.value = false;
        if (data.isNotEmpty) {
          users.assignAll(data.map((e) => UserModel.fromJson(e)).toList());
        } else {
          notFound.value = true;
        }
      } else {
        users.clear();
      }
      loading.value = false;
    });
  }
}
