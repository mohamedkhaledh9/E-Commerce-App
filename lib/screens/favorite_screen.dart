import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  static String id = "FavoriteScreen";
  String name = "default";
  bool hasThing = true;

  FavoriteScreen({this.name});

  FavoriteScreen.withoutThing({this.name}) : hasThing = false;

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Store _store = Store();
  List<Product> _products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Text(
                "Favorites",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 25,
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loadProduct(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (snapshot.data.docs[index][kIsFavorite] == true) {
                    return Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .35,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                    fit: BoxFit.fill,
                                    image: AssetImage(snapshot.data.docs[index]
                                        [kProductLocation])),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Opacity(
                                opacity: .6,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                snapshot.data.docs[index]
                                                    [kProductName],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                snapshot.data.docs[index]
                                                        [kProductPrice] +
                                                    "\$",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                size: 30,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                Map<String, bool>
                                                    favoriteValue = {
                                                  kIsFavorite: false,
                                                };
                                                _store.updateFavoriteState(
                                                    snapshot
                                                        .data.docs[index].id,
                                                    favoriteValue);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Colors.white,
                                  height:
                                      MediaQuery.of(context).size.height * .12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: 0.0,
                      height: 0.0,
                    );
                  }
                },
                itemCount: snapshot.data.docs.length,
              );
            } else {
              return Center(
                child: Text("No Favorite Items"),
              );
            }
          }),
    );
  }

  List<Product> getFavoriteProducts(bool favoriteValue) {
    List<Product> products = [];
    try {
      for (var _product in _products) {
        if (_product.isFavorite == true) {
          products.add(_product);
        }
      }
    } catch (e) {
      debugPrint(e);
    }
    return products;
  }
}
