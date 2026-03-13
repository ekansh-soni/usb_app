import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/ornament_controller.dart';
import '../service/database_helper.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Database helper - permanent
    Get.put<DatabaseHelper>(
      DatabaseHelper(),
      permanent: true,
    );

    // Auth Controller - permanent (kyuki app bhar chahiye)
    Get.put<AuthController>(
      AuthController(),
      permanent: true,
    );

    // Ornament Controller - lazy (jab use karo tab load)
    Get.lazyPut<OrnamentController>(
          () => OrnamentController(),
    );

    debugPrint('✅ All controllers initialized');
  }
}