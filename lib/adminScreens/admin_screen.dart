import 'package:chatapp/adminScreens/add_products.dart';
import 'package:chatapp/adminScreens/manage_product.dart';
import 'package:chatapp/adminScreens/orders_screen.dart';
import 'package:chatapp/constans.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  static String id = "AdminPage";

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kMainColor,
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text(
      //         "Admin Home Page",
      //         style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 22,
      //             color: Colors.white),
      //       ),
      //       Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(10),
      //           color: Colors.white,
      //         ),
      //         child: IconButton(
      //           icon: Icon(
      //             Icons.exit_to_app,
      //             size: 35,
      //             color: kMainColor,
      //           ),
      //           onPressed: () {
      //             Auth _auth = Auth();
      //             _auth.logOut();
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: kMainColor,
              height: screenSize.height,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                ),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage("images/appimages/shopbackground2.jpg"),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 50,
              child: Text(
                "Welcome To My Store",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 30,
              child: Row(
                children: [
                  CustomContainer(
                    navigateScreen: AddProducts(),
                    icon: Icons.add_box,
                    text: "Add Products",
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CustomContainer(
                    navigateScreen: ManageProduct(),
                    icon: Icons.edit,
                    text: "Manage Products",
                  ),
                ],
              ),
            ),
            Positioned(
              top: 400,
              left: 30,
              child: Row(
                children: [
                  CustomContainer(
                    navigateScreen: OrdersScreen(),
                    icon: Icons.bookmark_border,
                    text: "Orders",
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  // CustomContainer(),
                ],
              ),
            ),
            Container(
              width: screenSize.width,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Admin Controle Screen",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.exit_to_app,
                                    size: 35,
                                    color: kMainColor,
                                  ),
                                  onPressed: () {
                                    Auth _auth = Auth();
                                    _auth.logOut();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Text(
                                "Exit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
