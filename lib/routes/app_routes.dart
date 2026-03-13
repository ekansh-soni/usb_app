import 'package:get/get.dart';
import 'package:usb_app/view/summary_screen.dart';
import '../bindings/initial_bindings.dart';
import '../view/add_ornament_screen.dart';
import '../view/home_screen.dart';
import '../view/login_screen.dart';
import '../view/sign_up_screen.dart';
import '../view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String addOrnaments = '/add-ornament';
  static const String summary = '/summary';

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen(), binding: InitialBinding(),),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signUp, page: () => SignupScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: addOrnaments, page: () => AddOrnamentScreen()),
    GetPage(name: summary, page: () => SummaryScreen()),
  ];
}