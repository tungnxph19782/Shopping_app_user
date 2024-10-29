import 'package:flutter/material.dart';
import '../controller/order_controller.dart'; // Import OrderController
import '../model/order.dart';

class OrderScreen extends StatelessWidget {
  final OrderController orderController = OrderController(); // Khởi tạo controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử Đơn Hàng'),
      ),
      body: FutureBuilder<List<Order_user>>(
        future: orderController.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Tổng tiền: ${order.totalAmount} VND'),
                  subtitle: Text('Ngày tạo: ${order.createdAt}'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Chi Tiết Đơn Hàng'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: order.items.map((item) {
                            return ListTile(
                              title: Text('Sản phẩm ID: ${item.productId}'),
                              subtitle: Text(
                                'Số lượng: ${item.quantity}, Giá: ${item.price} VND',
                              ),
                            );
                          }).toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
