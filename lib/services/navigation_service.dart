import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/views/home/home_page.dart';
import 'package:threads_clone/views/notification/notifications_page.dart';
import 'package:threads_clone/views/profile/profile_page.dart';
import 'package:threads_clone/views/search/search_page.dart';
import 'package:threads_clone/views/threads/add_threads.dart';

class NavigationService extends GetxService {
  var currentIndex = 0.obs;
  var lastIndex = 0.obs;

  //all pages
  List<Widget> pages() {
    return [
       HomePage(),
      const SearchPage(),
      AddThreadsPage(),
      NotificationPage(),
      ProfilePage()
    ];
  }

  //update index
  updateIndex(int index) {
    lastIndex.value = currentIndex.value;
    currentIndex.value = index;
  }


  //back to previous page
  backToPreviousPage() {
    currentIndex.value = lastIndex.value;
  }
}
