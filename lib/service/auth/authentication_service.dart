import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Khởi tạo Firestore

  // Hàm đăng nhập
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // Đăng nhập thành công
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
      // Tạo tài khoản mới với email và mật khẩu
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy UID của người dùng mới tạo
      String uid = userCredential.user!.uid;

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('User Profiles').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Đăng ký thành công
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi Firebase
      return e.message;
    } catch (e) {
      // Xử lý lỗi khác
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
