import 'package:flutter/material.dart';
import '../model/product.dart';
import '../controller/cart_controller.dart';
import 'package:get/get.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final CartController cartController;

  CartItem({required this.product}) : cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        leading: Image.network(
          product.picture,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${product.price} VND'),
            Text('Số lượng: ${product.quantity}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _increaseQuantity();
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                _decreaseQuantity();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _increaseQuantity() {
    product.quantity++;
    cartController.updateCartQuantity(product, product.quantity); // Update quantity in Firestore
  }

  void _decreaseQuantity() {
    if (product.quantity > 1) {
      product.quantity--;
      cartController.updateCartQuantity(product, product.quantity); // Update quantity in Firestore
    } else {
      cartController.removeFromCart(product);
    }
  }
}
