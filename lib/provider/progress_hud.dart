import 'package:flutter/material.dart';

class ModelHud extends ChangeNotifier {
  bool isLoading = false;
  changeIsLoadind(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
