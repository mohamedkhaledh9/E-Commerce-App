import 'package:flutter/material.dart';

class IsAsmin extends ChangeNotifier {
  bool isAdmin = false;
  isAdminValue(bool value) {
    isAdmin = value;
    notifyListeners();
  }
}
