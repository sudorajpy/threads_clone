import 'package:get/get.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/views/auth/login.dart';
import 'package:threads_clone/views/auth/register.dart';
import 'package:threads_clone/views/chat/chat_room.dart';
import 'package:threads_clone/views/chat/inbox_screen.dart';
import 'package:threads_clone/views/home.dart';
import 'package:threads_clone/views/profile/edit_profile.dart';
import 'package:threads_clone/views/profile/followers_list.dart';
import 'package:threads_clone/views/profile/show_user.dart';
import 'package:threads_clone/views/replies/add_reply.dart';
import 'package:threads_clone/views/settings/settings.dart';
import 'package:threads_clone/views/threads/show_image.dart';
import 'package:threads_clone/views/threads/show_threads.dart';

class Routes {
  static final pages = [
    GetPage(
      name: RouteNames.home,
      page: () => Home(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.login,
      page: () => Login(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.register,
      page: () => RegisterScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.editProfile,
      page: () => EditProfile(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RouteNames.settings,
      page: () => SettingsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RouteNames.addReply,
      page: () => Addreply(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: RouteNames.showThread,
      page: () => ShowThreads(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RouteNames.showImage,
      page: () => ShowImage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RouteNames.showUser,
      page: () => ShowUser(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RouteNames.chatroom,
      page: () => ChatroomScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RouteNames.inbox,
      page: () => InboxScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RouteNames.followersList,
      page: () => FollowersListScreen(),
      transition: Transition.leftToRight,
    ),
  ];
}
