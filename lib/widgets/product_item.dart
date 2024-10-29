import 'package:flutter/material.dart';
import '../model/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddtoCart; // Callback cho việc thêm vào giỏ hàng

  const ProductItem({
    Key? key,
    required this.product,
    required this.onAddtoCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.picture, height: 100, width: double.infinity, fit: BoxFit.cover),
          Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\$${product.price.toStringAsFixed(2)}'),
          ElevatedButton(
            onPressed: onAddtoCart,
            child: const Text('Thêm vào giỏ hàng'),
          ),
        ],
      ),
    );
  }
}
