import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_items.dart';

class UserHomePage extends StatefulWidget {
  static String id = 'UserHomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UserHomePage> {
  int _tabBarIndex = 0;
  int _tabValue = 0;
  final _store = Store();
  List<Product> _products;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _tabBarIndex,
              type: BottomNavigationBarType.fixed,
              fixedColor: kMainColor,
              onTap: (value) async {
                Auth _auth = Auth();
                if (value == 1) {
                  SharedPreferences _SharedPreferences =
                      await SharedPreferences.getInstance();
                  _SharedPreferences.clear();
                  _auth.logOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }
                setState(() {
                  _tabBarIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: " person ",
                  icon: Icon(Icons.person),
                ),
                BottomNavigationBarItem(
                  label: "Log Out",
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabValue = value;
                  });
                },
                tabs: [
                  Text(
                    "Jackets",
                    style: TextStyle(
                      color: _tabValue == 0 ? Colors.black : Colors.grey,
                      fontSize: _tabValue == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    "Shoes",
                    style: TextStyle(
                      color: _tabValue == 1 ? Colors.black : Colors.grey,
                      fontSize: _tabValue == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    "Bags",
                    style: TextStyle(
                      color: _tabValue == 2 ? Colors.black : Colors.grey,
                      fontSize: _tabValue == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    "T-shirts",
                    style: TextStyle(
                      color: _tabValue == 3 ? Colors.black : Colors.grey,
                      fontSize: _tabValue == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                jacketView(kJackets),
                jacketView(kShoes),
                jacketView(kBags),
                jacketView(kTShirts),
                // productView(kShoes, _products),
                // productView(kBags, _products),
                // productView(kTShirts, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Container(
            height: MediaQuery.of(context).size.height * .1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "DISCOVER",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CartItems.id);
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget jacketView(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> prducts = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data;
            prducts.add(
              Product(
                pId: doc.id,
                pPrice: data()[kProductPrice],
                pName: data()[kProductName],
                pCategory: data()[kProductCategory],
                pLocation: data()[kProductLocation],
                pDescription: data()[kProductDescription],
              ),
            );
          }
          _products = [...prducts];
          prducts.clear();
          prducts = getProductByCategory(category);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .8,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: prducts[index]);
                },
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(prducts[index].pLocation),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: .6,
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prducts[index].pName,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$ ${prducts[index].pPrice}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            itemCount: prducts.length,
          );
        } else {
          return Center(
            child: Text("Loading ......"),
          );
        }
      },
    );
  }

  Widget productView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> prducts = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data;
            prducts.add(
              Product(
                pId: doc.id,
                pPrice: data()[kProductPrice],
                pName: data()[kProductName],
                pCategory: data()[kProductCategory],
                pLocation: data()[kProductLocation],
                pDescription: data()[kProductDescription],
              ),
            );
          }
          _products = [...prducts];
          prducts.clear();
          prducts = getProductByCategory(kShoes);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .8,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: prducts[index]);
                },
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(prducts[index].pLocation),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: .6,
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prducts[index].pName,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$ ${prducts[index].pPrice}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            itemCount: prducts.length,
          );
        } else {
          return Center(
            child: Text("Loading ......"),
          );
        }
      },
    );
  }

  List<Product> getProductByCategory(String categoryType) {
    List<Product> products = [];
    try {
      for (var _product in _products) {
        if (_product.pCategory == categoryType) {
          products.add(_product);
        }
      }
    } catch (e) {
      debugPrint(e);
    }
    return products;
  }
}
