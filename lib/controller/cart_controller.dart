import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs; // Danh sách sản phẩm trong giỏ hàng
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Thêm sản phẩm vào giỏ hàng và lưu vào Firestore
  Future<void> addToCart(Product product) async {
    try {
      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      final existingProductIndex = cartItems.indexWhere((item) => item.id == product.id);
      if (existingProductIndex != -1) {
        // Nếu sản phẩm đã có, cập nhật số lượng
        cartItems[existingProductIndex].quantity += 1;
      } else {
        // Nếu chưa có, thêm mới
        product.quantity = 1; // Khởi tạo số lượng cho sản phẩm
        cartItems.add(product);
      }

      // Lấy ID người dùng hiện tại
      final userId = _auth.currentUser?.uid;

      // Kiểm tra xem userId có tồn tại không
      if (userId != null) {
        // Lưu vào Firestore
        await _firestore.collection('carts').add({
          'productId': product.id, // Giả sử bạn có id trong model Product
          'userId': userId, // Sử dụng ID của người dùng hiện tại
          'quantity': product.quantity,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Xử lý lỗi nếu không tìm thấy userId
        throw Exception('User not authenticated');
      }
    } catch (e) {
      // Xử lý lỗi
      print('Error adding product to cart: $e');
    }
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng
  Future<void> updateCartQuantity(Product product, int newQuantity) async {
    try {
      // Tìm sản phẩm trong giỏ hàng
      final index = cartItems.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        // Cập nhật số lượng
        cartItems[index].quantity = newQuantity;

        // Lấy ID người dùng hiện tại
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          // Tìm và cập nhật số lượng trong Firestore
          final QuerySnapshot snapshot = await _firestore.collection('carts')
              .where('productId', isEqualTo: product.id)
              .where('userId', isEqualTo: userId)
              .get();

          for (var doc in snapshot.docs) {
            await doc.reference.update({
              'quantity': newQuantity, // Cập nhật số lượng trong Firestore
            });
          }
        }
      }
    } catch (e) {
      print('Error updating product quantity: $e');
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(Product product) async {
    try {
      // Tìm sản phẩm trong giỏ hàng
      final index = cartItems.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        cartItems.removeAt(index); // Xóa sản phẩm khỏi giỏ hàng

        // Lấy ID người dùng hiện tại
        final userId = _auth.currentUser?.uid;

        if (userId != null) {
          // Tìm và xóa sản phẩm khỏi Firestore
          final QuerySnapshot snapshot = await _firestore.collection('carts')
              .where('productId', isEqualTo: product.id)
              .where('userId', isEqualTo: userId)
              .get();

          for (var doc in snapshot.docs) {
            await doc.reference.delete(); // Xóa sản phẩm khỏi Firestore
          }
        }
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }

  // Lấy tổng số lượng sản phẩm trong giỏ hàng
  int get cartCount => cartItems.length;

  // Tính tổng tiền của giỏ hàng
  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Xóa tất cả sản phẩm trong giỏ hàng
  void clearCart() {
    cartItems.clear();
    // Xóa tất cả sản phẩm khỏi Firestore nếu cần
  }
}
