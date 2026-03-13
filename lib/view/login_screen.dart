import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usb_app/routes/app_routes.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _emailController = TextEditingController(text: "ekansh@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "123456789");
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              // Header
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.diamond,
                      size: 80,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade800,
                      ),
                    ),
                    Text(
                      'Apne jewelry ka hisaab rakhein',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'example@email.com',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter correct email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 15),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        hintText: '******',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password should be greater then 6 char';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

                    // Login Button
                    Obx(() =>
                    _authController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _authController.loginUser(
                             _emailController.text.trim(),
                             _passwordController.text.trim(),
                          );
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ),

                    SizedBox(height: 20),

                    // Signup Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New user? "),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.signUp),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}