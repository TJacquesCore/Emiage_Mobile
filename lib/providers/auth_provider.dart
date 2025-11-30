import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _currentUser;
  String? _userEmail;
  String? _userId;

  String? get currentUser => _currentUser;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    // Simulation d'une authentification (en production, faire un appel API)
    if (email.isNotEmpty && password.length >= 6) {
      // Simuler un délai réseau
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = email.split('@')[0];
      _userEmail = email;
      _userId = '${DateTime.now().millisecondsSinceEpoch}';
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Simulation d'une inscription
    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = name;
      _userEmail = email;
      _userId = '${DateTime.now().millisecondsSinceEpoch}';
      
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _userEmail = null;
    _userId = null;
    notifyListeners();
  }

  void updateProfile(String newName, String newEmail) {
    _currentUser = newName;
    _userEmail = newEmail;
    notifyListeners();
  }
}
