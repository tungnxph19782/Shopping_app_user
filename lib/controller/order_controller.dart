import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/order.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Order_user>> fetchOrders() async {
    String userId = _auth.currentUser?.uid ?? '';
    QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return Order_user.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
