import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:usb_app/routes/app_routes.dart';
import 'package:usb_app/service/database_helper.dart';
import 'package:usb_app/theme/app_theme.dart';
import 'bindings/initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {

    await DatabaseHelper().init();

    InitialBinding().dependencies();

    debugPrint('App initialized successfully');

    runApp(MyApp());

  } catch (e) {
    debugPrint('Error initializing app: $e');

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: GetMaterialApp(
        title: 'Jewelry App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.pages,
        defaultTransition: Transition.fadeIn,
      ),
    );
  }
}