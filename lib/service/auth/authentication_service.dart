import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm đăng nhập
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Không tìm thấy người dùng!';
        case 'wrong-password':
          return 'Sai mật khẩu!';
        default:
          return 'Lỗi: ${e.message}';
      }
    }
  }

  // Hàm đăng ký người dùng
  Future<String?> signupWithEmail(String name, String email, String password, String phone, String address) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;
      await _firestore.collection('User Profiles').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Lỗi xảy ra không mong muốn.';
    }
  }

  // Hàm đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Kiểm tra người dùng hiện tại
  User? get currentUser => _auth.currentUser;
}
