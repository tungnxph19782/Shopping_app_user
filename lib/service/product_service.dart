import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class ProductService {
  final CollectionReference _productRef =
  FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts() async {
    QuerySnapshot snapshot = await _productRef.get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
