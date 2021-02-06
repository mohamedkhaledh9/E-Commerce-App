import 'package:chatapp/screens/favorite_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/custom_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final auth = FirebaseAuth.instance;
  String userEmail;

  getCurrentUser() {
    setState(() {
      userEmail = auth.currentUser.email;
    });
  }

  @override
  void initState() {
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.purpleAccent),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white70,
                        child: Text(
                          userEmail.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, FavoriteScreen.id);
            },
            child: ListTile(
              title: Text("Favorites"),
              leading: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ),
          CustomDivider(),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
          ),
          CustomDivider(),
          ListTile(
            title: Text("About"),
            leading: Container(
                height: 25,
                width: 25,
                child: Image.asset("images/icons/qouestionmark.png")),
          ),
          CustomDivider(),
          GestureDetector(
            onTap: () async {
              SharedPreferences _SharedPreferences =
                  await SharedPreferences.getInstance();
              _SharedPreferences.clear();
              auth.signOut();
              Navigator.popAndPushNamed(context, LoginScreen.id);
            },
            child: ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.exit_to_app),
            ),
          ),
          CustomDivider(),
        ],
      ),
    );
  }
}
