import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../pages/payment_page.dart';
import '../widgets/cart_item.dart'; // Nhập màn hình thanh toán

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find(); // Lấy CartController đã khởi tạo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
      ),
      body: Obx(() {
        if (cartController.cartCount == 0) {
          return const Center(child: Text('Giỏ hàng rỗng'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartCount,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  return CartItem(product: product);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng tiền: ${cartController.totalAmount} VND', style: TextStyle(fontSize: 18)),
                  ElevatedButton(
                    onPressed: () {
                      // Chuyển sang màn hình thanh toán
                      Get.to(() => PaymentScreen());
                    },
                    child: const Text('Thanh Toán'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
