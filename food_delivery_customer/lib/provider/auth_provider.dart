import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _service;


  AuthProvider({required AuthService service}) : _service = service {
    user = _service.getCurrentUser();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? user;


  bool get isLoggedIn => user != null;

  // -------------------------
  // LOGIN
  // -------------------------
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.loginUserWithRoleCheck(
      email: email,
      password: password,
      requiredRole: "customer",
    );

    _isLoading = false;

    if (result == null) {
      user = _service.getCurrentUser();
      notifyListeners();
      return true; // success
    } else {
      _errorMessage = result;
      notifyListeners();
      return false;
    }
  }

  // -------------------------
  // SIGN UP
  // -------------------------
  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.createUser({
      'email': email,
      'password': password,
    });

    _isLoading = false;

    if (result == null) {
      user = _service.getCurrentUser();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result;
      notifyListeners();
      return false;
    }
  }


  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout() async {
    await _service.logout();
    user = null;
    notifyListeners();
  }

  // -------------------------
  // SEND PASSWORD RESET EMAIL
  // -------------------------
  Future<bool> sendResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.sendPasswordResetEmail(email);

    _isLoading = false;

    if (result == null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result;
      notifyListeners();
      return false;
    }
  }

  // -------------------------
  // CHANGE PASSWORD
  // -------------------------
  Future<bool> changePassword(String oldPass, String newPass) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.changePassword(
      oldPassword: oldPass,
      newPassword: newPass,
    );

    _isLoading = false;

    if (result == null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.sendPasswordResetEmail(email);

    _isLoading = false;

    if (result == null) return true;

    _errorMessage = result;
    notifyListeners();
    return false;
  }

  Future<bool> deleteCurrentUser({String? password}) async {
    _isLoading = true;
    notifyListeners();

    bool result = await _service.deleteUser(password: password);

    if (result) {
      user = null; // reset user như khi logout
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}