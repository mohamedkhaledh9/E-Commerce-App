import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:chatapp/widgets/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProducts extends StatefulWidget {
  static String id = 'AddProducts';

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _store = Store();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _name, _price, _description, _category, _location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Products",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: kMainColor,
      ),
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: Column(
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
            Container(
              width: MediaQuery.of(context).size.width * .7,
              height: MediaQuery.of(context).size.height * .09,
              child: Builder(
                builder: (context) => RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Add Product",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onPressed: () {
                    try {
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        _store.addProduct(Product(
                          pName: _name,
                          pPrice: _price,
                          pDescription: _description,
                          pCategory: _category,
                          pLocation: _location,
                        ));
                        _globalKey.currentState.reset();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Product Added"),
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
