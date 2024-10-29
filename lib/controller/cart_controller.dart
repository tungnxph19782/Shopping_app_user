import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToCart(Product product) async {
    try {
      final existingProductIndex = cartItems.indexWhere((item) => item.id == product.id);
      if (existingProductIndex != -1) {
        cartItems[existingProductIndex].quantity += 1;
      } else {
        product.quantity = 1;
        cartItems.add(product);
      }

      final userId = _auth.currentUser?.uid;

      if (userId != null) {
        await _firestore.collection('carts').add({
          'productId': product.id,
          'userId': userId,
          'quantity': product.quantity,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> updateCartQuantity(Product product, int newQuantity) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        cartItems[index].quantity = newQuantity;
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          final QuerySnapshot snapshot = await _firestore.collection('carts')
              .where('productId', isEqualTo: product.id)
              .where('userId', isEqualTo: userId)
              .get();

          for (var doc in snapshot.docs) {
            await doc.reference.update({
              'quantity': newQuantity,
            });
          }
        }
      }
    } catch (e) {
      print('Error updating product quantity: $e');
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        cartItems.removeAt(index);
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          final QuerySnapshot snapshot = await _firestore.collection('carts')
              .where('productId', isEqualTo: product.id)
              .where('userId', isEqualTo: userId)
              .get();

          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        }
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }


  int get cartCount => cartItems.length;
  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
  void clearCart() {
    cartItems.clear();
  }
}
