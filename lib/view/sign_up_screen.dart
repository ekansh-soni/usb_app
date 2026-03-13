import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),

              // Icon
              Icon(
                Icons.person_add,
                size: 80,
                color: Colors.amber,
              ),

              SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Naam',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Apna naam likho',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Naam to batao bhai';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

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
                    return 'Email to daal';
                  }
                  if (!value.contains('@')) {
                    return 'Sahi email daal';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                  hintText: '9876543210',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number to daal';
                  }
                  if (value.length != 10) {
                    return '10 digit ka number daal';
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
                    return 'Password to daal';
                  }
                  if (value.length < 6) {
                    return '6+ characters daal';
                  }
                  return null;
                },
              ),



              SizedBox(height: 30),

              // Signup Button
              Obx(() =>
              controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                 /*   controller.signUp(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      phone: _phoneController.text.trim(),
                    );*/

                    controller.signupUser({
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "phone": _phoneController.text,
                      "password": _passwordController.text
                    });
                  }
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ),

              SizedBox(height: 20),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account? "),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Login',
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
      ),
    );
  }
}