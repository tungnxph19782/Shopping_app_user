import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserProfile(); // Gọi hàm để lấy thông tin cá nhân

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Cá Nhân'),
      ),
      body: Obx(() {
        if (profileController.userProfile.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = profileController.userProfile;

        // TextEditingControllers để chỉnh sửa thông tin
        final nameController = TextEditingController(text: user['name']);
        final emailController = TextEditingController(text: user['email']);
        final phoneController = TextEditingController(text: user['phone']);
        final addressController = TextEditingController(text: user['address']);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Họ và tên'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Vui lòng nhập email hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return 'Vui lòng nhập số điện thoại hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Cập nhật thông tin người dùng
                      profileController.updateUserProfile({
                        'name': nameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'address': addressController.text,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cập nhật thông tin thành công')),
                      );
                    }
                  },
                  child: const Text('Lưu Thay Đổi'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
