import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider extends ChangeNotifier {
  static const String _key = 'current_address';
  String _currentAddress = "Enter location...";

  String get currentAddress => _currentAddress;

  LocationProvider() {
    _loadAddress();
  }

  void updateAddress(String newAddress) async {
    _currentAddress = newAddress;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newAddress);
  }

  void _loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAddress = prefs.getString(_key);
    if (savedAddress != null) {
      _currentAddress = savedAddress;
      notifyListeners();
    }
  }
}