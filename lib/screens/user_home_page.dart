import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/store.dart';
import 'package:chatapp/widgets/app_drawer.dart';
import 'package:chatapp/widgets/view_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
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
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: AppDrawer(),
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
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
                  fontSize: 18,
                ),
              ),
              Text(
                "Shoes",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                "Bags",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                "T-shirts",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Home",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: kMainColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CartItems.id);
                  },
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            productView(kJackets),
            productView(kShoes),
            productView(kBags),
            productView(kTShirts),
          ],
        ),
      ),
    );
  }

  Widget productView(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> prducts = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data;
            prducts.add(
              Product(
                isFavorite: data()[kIsFavorite],
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(prducts[index].pLocation),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      prducts[index].pName,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${prducts[index].pPrice}\$',
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
                                      color: prducts[index].isFavorite == true
                                          ? Colors.red
                                          : Colors.blueGrey,
                                    ),
                                    onPressed: () {
                                      print(prducts[index].pId);
                                      print(prducts[index].isFavorite);
                                      Map<String, bool> isFavoriteValue = {
                                        kIsFavorite: true,
                                      };
                                      Map<String, bool> isNotFavorite = {
                                        kIsFavorite: false,
                                      };
                                      if (prducts[index].isFavorite != true) {
                                        _store.updateFavoriteState(
                                            prducts[index].pId,
                                            isFavoriteValue);
                                        setState(() {});
                                      } else {
                                        _store.updateFavoriteState(
                                            prducts[index].pId, isNotFavorite);
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
