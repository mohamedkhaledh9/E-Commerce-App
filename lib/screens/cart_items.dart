import 'package:chatapp/constans.dart';
import 'package:chatapp/models/product_data.dart';
import 'package:chatapp/provider/provider_cart_items.dart';
import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/services/store.dart';
import 'package:chatapp/widgets/custom_magage_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
  static String id = "CardItems";

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    List<Product> _products = Provider.of<ProviderCartItem>(context).products;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                if (_products.isEmpty) {
                  return (Center(
                    child: Text("Your Cart Is Empty"),
                  ));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTapUp: (details) {
                        viewMenue(details, context, _products[index]);
                      },
                      child: Container(
                        color: kMainColor,
                        height: screenHeight * .1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage(_products[index].pLocation),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, right: 20),
                              child: Column(
                                children: [
                                  Text(
                                    _products[index].pName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '\$${_products[index].pPrice}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25),
                              child: Center(
                                child: Text(
                                  _products[index].pQuantity.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(
            width: 350,
            height: 80,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Builder(
                builder: (context) => RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: kMainColor,
                  onPressed: () {
                    showOrderDialog(_products, context);
                  },
                  child: Text("ORDER"),
                ),
              ),
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
        title: Text(
          'My Cart',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
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
              } catch (e) {}
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
