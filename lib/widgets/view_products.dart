import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constans.dart';

class ViewProducts extends StatefulWidget {
  final String type;

  ViewProducts({this.type});

  @override
  _ViewProductsState createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.loadProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .8,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                if (snapshot.data.docs[index][kProductCategory] ==
                    widget.type) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProductInfo.id,
                            arguments: snapshot.data.docs[index]);
                      },
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                fit: BoxFit.fill,
                                image: AssetImage(snapshot.data.docs[index]
                                    [kProductLocation]),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Opacity(
                              opacity: .6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]
                                                [kProductName],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${snapshot.data.docs[index][kProductPrice]}\$',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            size: 30,
                                            color: snapshot.data.docs[index]
                                                        [kIsFavorite] ==
                                                    true
                                                ? Colors.red
                                                : Colors.blueGrey,
                                          ),
                                          onPressed: () {
                                            Map<String, bool> isFavoriteValue =
                                                {
                                              kIsFavorite: true,
                                            };
                                            Map<String, bool> isNotFavorite = {
                                              kIsFavorite: false,
                                            };
                                            if (snapshot.data.docs[index]
                                                    [kIsFavorite] !=
                                                true) {
                                              _store.updateFavoriteState(
                                                  snapshot.data.docs[index].id,
                                                  isFavoriteValue);
                                              setState(() {});
                                            } else {
                                              _store.updateFavoriteState(
                                                  snapshot.data.docs[index].id,
                                                  isNotFavorite);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                }
              },
              itemCount: snapshot.data.docs.length,
            );
          } else {
            return Center(
              child: Text("No Products"),
            );
          }
        });
  }
}
