import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> createUser(Map<String, dynamic> data) async {
    try {

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );
      final uid = userCredential.user!.uid;

      await _fireStore.collection('users').doc(uid).set({
        'email': data['email'],
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already registered.';
      }
      return 'Registration failed. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  /// Đăng nhập và kiểm tra role
  Future<String?> loginUserWithRoleCheck({
    required String email,
    required String password,
    String requiredRole = "customer",
  }) async {
    try {
      // Đăng nhập
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final doc = await _fireStore.collection('users').doc(uid).get();

      if (!doc.exists) {
        await _auth.signOut();
        return "User record not found.";
      }

      final role = doc.data()?['role'];
      if (role != requiredRole) {
        await _auth.signOut();
        return "Access denied. You must be $requiredRole.";
      }

      return null; // Success
    } on FirebaseAuthException catch (_) {
      return 'Invalid email or password.';
    } catch (_) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User not found.";
      final email = user.email;
      if (email == null) return "Email not available for this account.";

      // Re-auth với mật khẩu cũ
      final cred = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(cred);

      // Đổi mật khẩu
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return "Old password is incorrect.";
        case 'weak-password':
          return "New password is too weak.";
        case 'requires-recent-login':
          return "Please log in again and try changing the password.";
        case 'user-not-found':
        case 'user-mismatch':
          return "User not found or mismatched.";
        case 'too-many-requests':
          return "Too many attempts. Please try again later.";
        default:
          return "Password change failed. Please try again.";
      }
    } catch (e) {
      // debugPrint('changePassword unknown error: $e');
      return "An error occurred. Please try again.";
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      }
      return 'Failed to send reset email. Please try again.';
    } catch (_) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}