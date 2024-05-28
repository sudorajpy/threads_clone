import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads_clone/models/likes_model.dart';
import 'package:threads_clone/models/post_model.dart';
import 'package:threads_clone/models/user_model.dart';
import 'package:threads_clone/services/supabase_service.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();

  @override
  void onInit() async {
    await fetchThreads();
    listenToThreadsRealtime();
    super.onInit();
  }

  Future<void> fetchThreads() async {
    loading.value = true;
    final List<dynamic> response =
        await SupabaseService.client.from('posts').select('''
id,content,image,created_at,comment_count, like_count, user_id,
user:user_id (email, metadata), likes:likes (user_id, post_id)
''').order("id", ascending: false);
    loading.value = false;
    // print("the posts are ${jsonEncode(response)}");
    if (response.isNotEmpty) {
      posts.value = response.map((e) => PostModel.fromJson(e)).toList();
    }
  }

//listen to real time threads changes
  listenToThreadsRealtime() async {
    SupabaseService.client
        .channel('public:posts')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'posts',
            callback: (payload) {
              print('Change received: ${payload.eventType}');
              if (payload.eventType.toString() ==
                  "PostgresChangeEvent.update") {
                print("truuuuuuuuuuuuuuuuuuuu");
                print(payload.toString());
                int indexxx = posts.indexWhere(
                    (element) => element.id == payload.newRecord['id']);
                print(indexxx);
                final PostModel post = PostModel.fromJson(payload.newRecord);
                getUserAndLikesCount(post, indexxx);
                // posts[indexxx] = post;
              } else if (payload.eventType.toString() ==
                  "PostgresChangeEvent.insert") {
                final PostModel post = PostModel.fromJson(payload.newRecord);
                updateFeed(post);
              } else if (payload.eventType.toString() ==
                  "PostgresChangeEvent.delete") {
                print('Delete event received: ${payload.toString()}');
                final postId = payload.oldRecord['id'];
                posts.removeWhere((element) => element.id == postId);
              }
            })
        // .onPostgresChanges(
        //     event: PostgresChangeEvent.delete,
        //     schema: 'public',
        //     table: 'posts',
        //     callback: (payload) {
        //       print('Delete event received: ${payload.toString()}');
        //       final postId = payload.oldRecord['id'];
        //       posts.removeWhere((element) => element.id == postId);
        //     })
        .subscribe();
  }

  //to update the feed
  updateFeed(PostModel post) async {
    var user = await SupabaseService.client
        .from('users')
        .select("*")
        .eq("id", post.userId!)
        .single();

    post.likes = [];
    post.user = UserModel.fromJson(user);
    posts.insert(0, post);
  }

  getUserAndLikesCount(PostModel post, int index) async {
    var user = await SupabaseService.client
        .from('users')
        .select("*")
        .eq("id", post.userId!)
        .single();

    post.user = UserModel.fromJson(user);

    var likes = await SupabaseService.client
        .from('likes')
        .select("*")
        .eq("post_id", post.id!);

    post.likes = likes.map((like) => LikesModel.fromJson(like)).toList();

    posts[index] = post;

    // List<dynamic> response = await SupabaseService.client
    //     .from('likes')
  }
}
