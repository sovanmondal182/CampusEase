import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campus_ease/models/user.dart' as UserModel;

class AuthNotifier extends ChangeNotifier {
  User? _user;

  User? get user {
    return _user;
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Test
  UserModel.User? _userDetails;

  UserModel.User? get userDetails => _userDetails;

  setUserDetails(UserModel.User user) {
    _userDetails = user;
    notifyListeners();
  }
}
