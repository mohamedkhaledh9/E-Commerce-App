import 'package:chatapp/adminScreens/order_details.dart';
import 'package:chatapp/constans.dart';
import 'package:chatapp/models/orders_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static String id = 'OrdersScreen';
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('There Is No Orders Yet'),
            );
          } else {
            List<Orders> _orders = [];
            for (var _order in snapshot.data.docs) {
              _orders.add(
                Orders(
                    docId: _order.id,
                    totalPrice: _order.data()[kTotalPrice],
                    adress: _order.data()[kAddress]),
              );
            }
            return ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, OrederDetails.id,
                            arguments: _orders[index].docId);
                      },
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
                                'Total Price = \$${_orders[index].totalPrice}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Adress : ${_orders[index].adress}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
