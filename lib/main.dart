import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footware_user/pages/home_page.dart';
import 'package:footware_user/pages/login_page.dart';
import 'package:get/get.dart';

import 'controller/cart_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter binding đã được khởi tạo
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Khởi tạo Firebase
  Get.put(CartController());
  runApp(const MyApp()); // Chạy ứng dụng
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,// Sử dụng GetMaterialApp để hỗ trợ GetX
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Thay thế bằng trang chính của bạn
    );
  }
}