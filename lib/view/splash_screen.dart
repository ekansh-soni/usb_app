import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usb_app/routes/app_routes.dart';
import 'package:usb_app/service/shared_preference_helper.dart';
import '../controller/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // 2 second baad navigate karo
    Future.delayed(Duration(seconds: 2), () {
      if (SharedPreferencesHelper().getBool("isLogin")== true) {
        Get.offNamed(AppRoutes.home);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.shade300, Colors.amber.shade700],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(seconds: 1),
                curve: Curves.elasticOut,
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      Icons.diamond,
                      size: 100,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Jewelry App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Manage Your Ornaments',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}