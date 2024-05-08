import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/services/navigation_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final NavigationService navigationService = Get.put(NavigationService());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: AnimatedSwitcher(
         duration: Duration(milliseconds: 500),
         switchInCurve: Curves.ease,
         switchOutCurve: Curves.easeInOut,
         child: navigationService.pages()[navigationService.currentIndex.value],

      ),
            bottomNavigationBar: NavigationBar(
          selectedIndex: navigationService.currentIndex.value,
          onDestinationSelected: (value)=> navigationService.updateIndex(value),
          
          destinations: const <Widget>[
            NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home", selectedIcon: Icon(Icons.home),),
            NavigationDestination(icon: Icon(Icons.search_outlined), label: "Search", selectedIcon: Icon(Icons.search),),
            NavigationDestination(icon: Icon(Icons.add_outlined), label: "Add", selectedIcon: Icon(Icons.add),),
            NavigationDestination(icon: Icon(Icons.favorite_outline), label: "Notifications", selectedIcon: Icon(Icons.favorite),),
            NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile", selectedIcon: Icon(Icons.person),),
          ],
        )));
  }
}
