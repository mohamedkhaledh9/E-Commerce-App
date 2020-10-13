import 'package:chatapp/adminScreens/add_products.dart';
import 'package:chatapp/adminScreens/manage_product.dart';
import 'package:chatapp/adminScreens/orders_screen.dart';
import 'package:chatapp/constans.dart';
import 'package:chatapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  static String id = "AdminPage";

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Main Page",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Auth _auth = Auth();
            _auth.logOut();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: kMainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .1,
              color: kMainColor,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Add Products"),
                onPressed: () {
                  Navigator.pushNamed(context, AddProducts.id);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .1,
              color: kMainColor,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Edit Products"),
                onPressed: () {
                  Navigator.pushNamed(context, ManageProduct.id);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .1,
              color: kMainColor,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text("View Orders"),
                onPressed: () {
                  Navigator.pushNamed(context, OrdersScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
