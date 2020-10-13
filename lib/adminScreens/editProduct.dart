import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:chatapp/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

import '../constans.dart';

class EditProduct extends StatefulWidget {
  static String id = "EditProduct";

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _store = Store();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _name, _price, _description, _category, _location;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 130),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomFormField(
                    hint: 'Product Name',
                    onClic: (value) {
                      _name = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomFormField(
                    hint: 'Product Price',
                    onClic: (value) {
                      _price = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomFormField(
                    hint: 'Product Description',
                    onClic: (value) {
                      _description = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomFormField(
                    hint: 'Product Categeory',
                    onClic: (value) {
                      _category = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomFormField(
                    hint: 'Product Locaion',
                    onClic: (value) {
                      _location = value;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    child: Text("Edit Product"),
                    onPressed: () {
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        _globalKey.currentState.reset();
                        _store.editProduct(
                            ({
                              kProductName: _name,
                              kProductPrice: _price,
                              kProductDescription: _description,
                              kProductCategory: _category,
                              kProductLocation: _location,
                            }),
                            product.pId);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
