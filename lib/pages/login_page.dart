import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footware_user/pages/home_page.dart';
import 'package:footware_user/pages/signup_page.dart';
import 'package:footware_user/service/auth/authentication_service.dart';
import 'package:get/get.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng Nhập',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            CustomTextField(
              label: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Mật khẩu',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Đăng Nhập',
              onPressed: _login,
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Get.to(() => const SignupPage()); // Điều hướng bằng GetX
              },
              child: const Text(
                'Chưa có tài khoản? Đăng ký',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    final errorMessage = await _authService.loginWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );
      Get.to(() => HomeScreen());
    } else {
      // Hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
