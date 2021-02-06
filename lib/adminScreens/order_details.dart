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
    print(docId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          "Order Details",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
                  pLocation: doc.data()[kProductLocation],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      if (_products.isNotEmpty) {
                        print(_products[index].pLocation);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kMainColor,
                            ),
                            height: MediaQuery.of(context).size.height * .15,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: 100,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          _products[index].pLocation,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        'Price = \$${_products[index].pPrice}',
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
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.deepPurple,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .38,
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              "Confirm Order",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .38,
                          child: MaterialButton(
                            onPressed: () async {
                              // _store.deletOrder(docId);
                              AlertDialog _alertDialog = AlertDialog(
                                title: Text(
                                  "Warning !",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                content: Text(
                                  "Are you sure to delete this order !!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: RaisedButton(
                                          onPressed: () {
                                            _store.deletOrder(docId);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Delete any way"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _alertDialog;
                                  });
                            },
                            child: Text(
                              "Delet Oreder",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
