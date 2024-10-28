import 'package:flutter/material.dart';
import 'package:footware_user/pages/oder_page.dart';
import 'package:footware_user/pages/profile_page.dart';
import 'package:get/get.dart';
import '../service/product_service.dart';
import '../model/product.dart';
import '../widgets/product_item.dart';
import 'cart_page.dart';
import 'product_details.dart';
 // Màn hình lịch sử mua hàng
// Màn hình thông tin cá nhân
import '../controller/cart_controller.dart'; // Import controller

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final CartController cartController = Get.find<CartController>(); // Lấy instance của CartController

  int _currentIndex = 0; // Biến lưu chỉ mục hiện tại của BottomNavigationBar

  // Danh sách các màn hình tương ứng với từng mục
  final List<Widget> _screens = [
    HomeContent(), // Nội dung trang chủ
     OrderScreen(), // Màn hình lịch sử mua hàng
     ProfileScreen(), // Màn hình thông tin cá nhân
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Sản Phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(() => CartScreen());
            },
          ),
        ],
      ),
      body: _screens[_currentIndex], // Hiển thị màn hình dựa vào chỉ mục hiện tại
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Chỉ mục hiện tại
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật chỉ mục khi người dùng chọn
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử mua',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Thông tin cá nhân',
          ),
        ],
      ),
    );
  }
}

// Nội dung của màn hình trang chủ
class HomeContent extends StatelessWidget {
  final ProductService _productService = ProductService();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productService.fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào'));
        }

        final products = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailScreen(product: product));
              },
              child: ProductItem(
                product: product,
                onAddtoCart: () {
                  cartController.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
