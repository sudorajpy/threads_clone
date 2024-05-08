import 'package:get/get.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/views/auth/login.dart';
import 'package:threads_clone/views/auth/register.dart';
import 'package:threads_clone/views/home.dart';
import 'package:threads_clone/views/profile/edit_profile.dart';
import 'package:threads_clone/views/settings/settings.dart';

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
  ];
}
