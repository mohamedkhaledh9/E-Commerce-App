import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/provider/provider_cart_items.dart';
import 'package:chatapp/screens/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quaintity = 1;

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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(product.pLocation),
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
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            child: Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Opacity(
                    opacity: .5,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.pName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\$${product.pPrice}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              product.pDescription,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 40,
                                  onPressed: () {
                                    increaseQuantity();
                                  },
                                  icon: Icon(Icons.add),
                                  color: kMainColor,
                                ),
                                Text(
                                  _quaintity.toString(),
                                  style: TextStyle(fontSize: 40),
                                ),
                                IconButton(
                                    color: kMainColor,
                                    iconSize: 40,
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      decreaseQuantity();
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Builder(
                    builder: (context) => RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        ProviderCartItem _addItems =
                            Provider.of<ProviderCartItem>(context,
                                listen: false);
                        product.pQuantity = _quaintity;
                        bool exist = false;
                        var productsInCart = _addItems.products;
                        for (var productsInCart in productsInCart) {
                          if (productsInCart.pLocation == product.pLocation) {
                            exist = true;
                          }
                        }
                        if (exist) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("You Added This Item Befor"),
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
                      child: Text("Add To My Cart"),
                      color: kMainColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
