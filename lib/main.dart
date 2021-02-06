import 'package:chatapp/adminScreens/add_products.dart';
import 'package:chatapp/adminScreens/editProduct.dart';
import 'package:chatapp/adminScreens/manage_product.dart';
import 'package:chatapp/adminScreens/order_details.dart';
import 'package:chatapp/adminScreens/orders_screen.dart';
import 'package:chatapp/adminScreens/view_order_location.dart';
import 'package:chatapp/constans.dart';
import 'package:chatapp/provider/admin_check.dart';
import 'package:chatapp/provider/provider_cart_items.dart';
import 'package:chatapp/provider/progress_hud.dart';
import 'package:chatapp/screens/cart_items.dart';
import 'package:chatapp/screens/favorite_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/map_screen.dart';
import 'package:chatapp/screens/product_info.dart';
import 'package:chatapp/screens/sign_up_screen.dart';
import 'package:chatapp/screens/user_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'adminScreens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Loading ...."),
              ),
            ),
          );
        } else {
          isUserLoggedIn = snapshot.data.getBool(kKeepMeLogedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ModelHud(),
              ),
              ChangeNotifierProvider(
                create: (context) => IsAsmin(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProviderCartItem(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
              initialRoute: isUserLoggedIn ? UserHomePage.id : LoginScreen.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                SignUp.id: (context) => SignUp(),
                UserHomePage.id: (context) => UserHomePage(),
                AdminPage.id: (context) => AdminPage(),
                AddProducts.id: (context) => AddProducts(),
                ManageProduct.id: (context) => ManageProduct(),
                EditProduct.id: (context) => EditProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartItems.id: (context) => CartItems(),
                OrdersScreen.id: (context) => OrdersScreen(),
                OrederDetails.id: (context) => OrederDetails(),
                GoogleMapScreen.id: (context) => GoogleMapScreen(),
                ViewOrderLocation.id: (context) => ViewOrderLocation(),
                FavoriteScreen.id:(context)=>FavoriteScreen(),
              },
            ),
          );
        }
      },
    );
  }
}
