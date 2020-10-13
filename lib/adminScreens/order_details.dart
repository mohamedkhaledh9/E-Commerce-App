import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrederDetails extends StatelessWidget {
  static String id = 'OrderDetails';
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    String docId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadDetails(docId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> _products = [];
            for (var doc in snapshot.data.docs) {
              _products.add(
                Product(
                  pName: doc.data()[kProductName],
                  pPrice: doc.data()[kProductPrice],
                  pQuantity: doc.data()[kProductQuantity],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: kMainColor,
                          height: MediaQuery.of(context).size.height * .15,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name : ${_products[index].pName}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  'Total Price = \$${_products[index].pPrice}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  'Quantity : ${_products[index].pQuantity}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        child: Text("Confirm Order"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kMainColor,
                      ),
                      RaisedButton(
                        onPressed: () {
                          _store.deletOrder(docId);
                        },
                        child: Text("Delet Oreder"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kMainColor,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("No Orders Yet"),
            );
          }
        },
      ),
    );
  }
}
