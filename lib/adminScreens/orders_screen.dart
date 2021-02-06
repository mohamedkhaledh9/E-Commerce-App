import 'package:chatapp/adminScreens/order_details.dart';
import 'package:chatapp/adminScreens/view_order_location.dart';
import 'package:chatapp/constans.dart';
import 'package:chatapp/models/orders_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersScreen extends StatefulWidget {
  static String id = 'OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Store _store = Store();

  GeoPoint orderLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Orders",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: kMainColor,
      ),
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
                  adress: _order.data()[kAddress],
                  orderLocationPoint: _order.data()[kOrderLocationPoint],
                ),
              );
            }
            return ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  if (_orders[index].adress != null &&
                      _orders[index].totalPrice != null) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.height * .22,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price = \$${_orders[index].totalPrice}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Expanded(
                                child: Text(
                                  'Adress : ${_orders[index].adress}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, OrederDetails.id,
                                            arguments: _orders[index].docId);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        height: 30,
                                        width: 130,
                                        child: Center(
                                            child: Text("View Order Details")),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          orderLocation=_orders[index].orderLocationPoint;
                                        });
                                        Navigator.pushNamed(context,ViewOrderLocation.id,arguments: orderLocation);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 140,
                                        child: Center(
                                            child: Text("View Order Location")),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          }
        },
      ),
    );
  }
}
