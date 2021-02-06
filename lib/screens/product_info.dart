import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/provider/provider_cart_items.dart';
import 'package:chatapp/screens/cart_items.dart';
import 'package:chatapp/services/store.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quaintity = 1;
  bool isFavorite ;

  void increaseQuantity() {
    setState(() {
      _quaintity++;
    });
  }

  void decreaseQuantity() {
    if (_quaintity > 1) {
      setState(() {
        _quaintity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: kMainColor,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
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
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 3,
                thickness: 3,
                color: kMainColor,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    //height: 500,
                    margin: EdgeInsets.only(top: size.height * .4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            child: Text(
                              product.pDescription,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black26,
                                  fontSize: 22),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 32,
                                    width: 40,
                                    child: OutlineButton(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      onPressed: decreaseQuantity,
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _quaintity.toString(),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                    width: 40,
                                    child: OutlineButton(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      onPressed: increaseQuantity,
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: product.isFavorite == true
                                      ? Colors.red
                                      : Colors.blueGrey,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Store _store = Store();
                                  Map<String, bool> isFavoriteValue = {
                                    kIsFavorite: true,
                                  };
                                  Map<String, bool> isNotFavorite = {
                                    kIsFavorite: false,
                                  };
                                  if (product.isFavorite != true) {
                                    _store.updateFavoriteState(
                                        product.pId, isFavoriteValue);
                                  } else {
                                    _store.updateFavoriteState(
                                        product.pId, isNotFavorite);
                                  }
                                },

                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: kMainColor,
                                      radius: 40,
                                      child: Icon(
                                        Icons.shopping_cart,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                        top: 30,
                                        bottom: 0,
                                        left: 25,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.add,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        )),
                                  ],
                                ),
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kMainColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 50,
                                  child: Builder(
                                    builder: (context) => FlatButton(
                                      onPressed: () {
                                        ProviderCartItem _addItems =
                                            Provider.of<ProviderCartItem>(
                                                context,
                                                listen: false);
                                        product.pQuantity = _quaintity;
                                        bool exist = false;
                                        var productsInCart = _addItems.products;
                                        for (var productsInCart
                                            in productsInCart) {
                                          if (productsInCart.pLocation ==
                                              product.pLocation) {
                                            exist = true;
                                          }
                                        }
                                        if (exist) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "You Added This Item Befor"),
                                            ),
                                          );
                                        } else {
                                          _addItems.addItems(product);
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Item Added"),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Add To Card",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Product Type :\t" + product.pCategory,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            product.pName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: "Price \n"),
                                    TextSpan(
                                        text: "\t" + product.pPrice + "\$",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: Container(
                                    height: size.height * .3,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        product.pLocation,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
