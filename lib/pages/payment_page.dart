import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatelessWidget {
  final CartController cartController = Get.find(); // Lấy CartController đã khởi tạo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán'),
      ),
      body: Obx(() {
        if (cartController.cartCount == 0) {
          return const Center(child: Text('Giỏ hàng rỗng'));
        }

        double totalAmount = cartController.cartItems.fold(
          0.0,
              (sum, item) => sum + (item.price * item.quantity),
        );

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi tiết đơn hàng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartCount,
                  itemBuilder: (context, index) {
                    final product = cartController.cartItems[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price} VND x ${product.quantity}'),
                      trailing: Text('${product.price * product.quantity} VND'),
                    );
                  },
                ),
              ),
              const Divider(),
              Text(
                'Tổng cộng: ${totalAmount} VND',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _confirmPayment(totalAmount);
                },
                child: const Text('Xác nhận thanh toán'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _confirmPayment(double totalAmount) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng đăng nhập để thanh toán!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': userId,
        'items': cartController.cartItems.map((item) => {
          'productId': item.id,
          'quantity': item.quantity,
          'price': item.price,
        }).toList(),
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Thanh toán thành công',
        'Cảm ơn bạn đã mua sắm!',
        snackPosition: SnackPosition.BOTTOM,
      );

      cartController.clearCart();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Lỗi thanh toán',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error confirming payment: $e');
    }
  }
}
