import 'package:flutter/foundation.dart';

enum AuthRole { none, customer, admin }

class AuthState extends ChangeNotifier {
  AuthRole _role = AuthRole.none;

  bool get isSignedIn => _role != AuthRole.none;
  bool get isAdmin => _role == AuthRole.admin;

  void signInAs(AuthRole role) {
    _role = role;
    notifyListeners();
  }

  void signOut() {
    _role = AuthRole.none;
    notifyListeners();
  }
}
