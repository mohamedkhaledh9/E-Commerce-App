import 'package:chatapp/adminScreens/editProduct.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/services/store.dart';
import 'package:chatapp/widgets/custom_magage_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constans.dart';

class ManageProduct extends StatefulWidget {
  static String id = 'ManageProduct';

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70),
                height: 40,
                width: 50,
                child: Icon(Icons.arrow_back),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                width: 250,
                height: 40,
                child: Center(child: Text(" Manage All Products")),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: kMainColor,
      ),
      backgroundColor: kMainColor,
      body: StreamBuilder<QuerySnapshot>(
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
                  onTapUp: (dimentions) {
                    print(prducts[index].pId);
                    double dx = dimentions.globalPosition.dx;
                    double dy = dimentions.globalPosition.dy;
                    double dx2 = MediaQuery.of(context).size.width - dx;
                    double dy2 = MediaQuery.of(context).size.width - dy;
                    showMenu(
                      context: (context),
                      position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                      items: [
                        MyPopUpMenueItem(
                          onClic: () {
                            Navigator.pushNamed(context, EditProduct.id,
                                arguments: prducts[index]);
                          },
                          child: Text("Edit"),
                        ),
                        MyPopUpMenueItem(
                          child: Text("Delete"),
                          onClic: () {
                            _store.deleteProduct(prducts[index].pId);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
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
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Opacity(
                            opacity: .6,
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prducts[index].pName,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '\$ ${prducts[index].pPrice}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
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
            return Center(child: Text("Loading ......"));
          }
        },
      ),
    );
  }
}
