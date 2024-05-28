import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/search_controller.dart';
import 'package:threads_clone/widgets/loading_widget.dart';
import 'package:threads_clone/widgets/search_input.dart';
import 'package:threads_clone/widgets/user_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textEditingController = TextEditingController();
  var controller = Get.put(SearchUserController());

  searchUser(String? name) {
    if (name != null) {
      controller.searchUser(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: false,
            title: Text(
              'Search',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            expandedHeight: 105,
            collapsedHeight: 80,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 80, right: 10, left: 10),
              child: SearchInput(
                callBack: searchUser,
                controller: textEditingController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => controller.loading.value
                  ? LoadingWidget()
                  : Column(
                      children: [
                        if (controller.users.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: controller.users.length,
                            itemBuilder: (context, index) {
                              return UserTile(user: controller.users[index]);
                            },
                          )
                        else if (controller.users.isEmpty &&
                            controller.notFound.value)
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('User not found'),
                          )
                        else
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text('Search for a user'),
                            ),
                          ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
