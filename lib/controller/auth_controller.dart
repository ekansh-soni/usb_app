import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../service/database_helper.dart';
import '../service/toast_service.dart'; // ✅ Import toast service

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<UserModel>();

  late DatabaseHelper _dbHelper;

  @override
  void onInit() {
    super.onInit();
    _dbHelper = Get.find<DatabaseHelper>();
    debugPrint('✅ AuthController initialized');
  }

  // Sign Up function
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      // Check if email already exists
      bool emailExists = await _dbHelper.isEmailExists(email);

      if (emailExists) {
        ToastService.showError("Ye email already registered hai!");
        isLoading.value = false;
        return;
      }

      // Create new user
      UserModel newUser = UserModel(
        name: name,
        email: email,
        password: password,
        phone: phone,
        createdAt: DateTime.now().toIso8601String(),
      );

      int id = await _dbHelper.registerUser(newUser);

      if (id != -1) {
        newUser.id = id;
        currentUser.value = newUser;
        isLoggedIn.value = true;

        ToastService.showSuccess("Signup successful! 🎉");
        Get.offAllNamed('/home');
      } else {
        ToastService.showError("Signup failed! Try again.");
      }
    } catch (e) {
      ToastService.showError("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Login function
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      bool emailExists = await _dbHelper.isEmailExists(email);

      if(!emailExists){
        return ToastService.showError("User with this email not exist");
      }

      UserModel? user = await _dbHelper.loginUser(email, password);

      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;

        ToastService.showSuccess("Welcome back, ${user.name}! 👋");
        Get.offAllNamed('/home');
      } else {
        ToastService.showError("Incorrect password!");
      }
    } catch (e) {
      debugPrint("$e");
      ToastService.showError("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
    ToastService.showInfo("Logged out successfully!");
  }
}