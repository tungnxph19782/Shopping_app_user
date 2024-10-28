import 'package:flutter/material.dart';
import 'package:footware_user/pages/login_page.dart';
import 'package:get/get.dart';
import '../service/auth/authentication_service.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final AuthService _authService = AuthService();

  // Hàm đăng ký
  void _signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (password != confirmPassword) {
      _showSnackbar('Mật khẩu không khớp');
      return;
    }

    final errorMessage = await _authService.signupWithEmail(name, email, password, phone, address);

    if (errorMessage == null) {
      _showSnackbar('Đăng ký thành công!');
      Get.to(() => LoginPage()); // Chuyển về màn hình login
    } else {
      _showSnackbar(errorMessage);
    }
  }

  // Hàm hiển thị Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Ký')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng Ký',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            CustomTextField(
              label: 'Họ và Tên',
              controller: nameController,
              inputType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Email',
              controller: emailController,
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Mật khẩu',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Xác nhận mật khẩu',
              controller: confirmPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Số điện thoại',
              controller: phoneController,
              inputType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Địa chỉ',
              controller: addressController,
              inputType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Đăng Ký',
              onPressed: _signup,
            ),
          ],
        ),
      ),
    );
  }
}
