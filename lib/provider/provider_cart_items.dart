import 'package:chatapp/models/product_data.dart';
import 'package:flutter/material.dart';

class ProviderCartItem extends ChangeNotifier {
  List<Product> products = [];
  addItems(Product product) {
    products.add(product);
    notifyListeners();
  }

  deleteItems(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
