import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userProfile = {}.obs; // Lưu thông tin người dùng

  // Lấy thông tin cá nhân của người dùng từ Firestore
  Future<void> fetchUserProfile() async {
    String userId = _auth.currentUser?.uid ?? '';
    print(userId);
    DocumentSnapshot doc = await _firestore.collection('User Profiles').doc(userId).get();
    userProfile.value = doc.data() as Map<String, dynamic>;
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    String userId = _auth.currentUser?.uid ?? '';
    await _firestore.collection('User Profiles').doc(userId).update(updatedData);
    userProfile.value = updatedData; // Cập nhật lại state
  }
}
