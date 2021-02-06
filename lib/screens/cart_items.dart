import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/provider/provider_cart_items.dart';
import 'package:chatapp/screens/map_screen.dart';
import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/services/store.dart';
import 'package:chatapp/widgets/custom_magage_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
  static String id = "CardItems";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    List<Product> _products = Provider.of<ProviderCartItem>(context).products;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                if (_products.length == 0) {
                  return Center(
                    child: Text(
                      "Your Cart Is Empty",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTapUp: (details) {
                        viewMenue(details, context, _products[index]);
                      },
                      child: Builder(
                        builder: (context) => Dismissible(
                          background: Container(
                            decoration: BoxDecoration(color: Colors.red),
                            child: Row(
                              children: [
                                Spacer(),
                                Image.asset("images/icons/trashicon.png"),
                              ],
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (diriction) {
                            Provider.of<ProviderCartItem>(context,
                                    listen: false)
                                .deleteItems(_products[index]);
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Item Deleted"),
                                action: SnackBarAction(
                                  label: "Undo",
                                  onPressed: () {
                                    Product p = _products[index];
                                    Provider.of<ProviderCartItem>(context,
                                            listen: false)
                                        .addItems(
                                      _products[index],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          key: Key(_products[index].pLocation),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth * .25,
                                      child: AspectRatio(
                                        aspectRatio: .88,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              _products[index].pLocation,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _products[index].pName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                _products[index].pPrice + "\$",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "\t X${_products[index].pQuantity}",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'My Cart',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _products.length.toString() + "\t items",
              style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Colors.grey,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("images/icons/ordericon3.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Voucher Code >>",
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "Total\:\n"),
                      TextSpan(
                        text:
                            "${"\t" + getTotalPrice(_products).toString() + "\$"}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Builder(
                          builder: (context) => RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: kMainColor,
                            onPressed: () {
                              if (_products.isNotEmpty) {
                                // showOrderDialog(_products, context);
                                Navigator.pushNamed(context, GoogleMapScreen.id,
                                    arguments: _products);
                              } else {
                                return Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Your Card is Empty !!!"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Order Now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
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

  viewMenue(dimentions, context, product) {
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
            Navigator.pop(context);

            Provider.of<ProviderCartItem>(context, listen: false)
                .deleteItems(product);
            Navigator.pushNamed(context, ProductInfo.id, arguments: product);
          },
          child: Text("Edit"),
        ),
        MyPopUpMenueItem(
          onClic: () {
            Navigator.pop(context);

            Provider.of<ProviderCartItem>(context, listen: false)
                .deleteItems(product);
          },
          child: Text("Delete"),
        ),
      ],
    );
  }

  showOrderDialog(List<Product> products, context) async {
    var price = getTotalPrice(products);
    String adress;
    AlertDialog _alertDialog = AlertDialog(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: MaterialButton(
            onPressed: () {
              Store _store = Store();
              if (products.isNotEmpty && adress != null) {
                try {
                  _store.orders({
                    kTotalPrice: price,
                    kAddress: adress,
                  }, products);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Order Confirmed"),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              } else {
                return Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please check your address"),
                  ),
                );
              }
            },
            child: Text(
              "Confirm",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        )
      ],
      content: TextField(
        onChanged: (value) {
          adress = value;
        },
        decoration: InputDecoration(hintText: "Enter Your Adress"),
      ),
      title: Text("Total Price =\$$price"),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return _alertDialog;
        });
  }

  getTotalPrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += int.parse(product.pPrice) * product.pQuantity;
    }
    return price;
  }
}
