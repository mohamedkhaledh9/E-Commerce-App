import 'package:chatapp/adminScreens/admin_screen.dart';
import 'package:chatapp/provider/admin_check.dart';
import 'package:chatapp/provider/progress_hud.dart';
import 'package:chatapp/screens/sign_up_screen.dart';
import 'package:chatapp/screens/user_home_page.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/customtextfield.dart';
import 'package:chatapp/widgets/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constans.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;

  final _user = Auth();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool keepMeLoggedIn = false;
  final String adminPassword = 'admin12345';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: Stack(
            children: [
              Image(
                image: AssetImage("images/appimages/shop6.jpg"),
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              ListView(
                children: [
                  AppLogo(),
                  SizedBox(
                    height: height * .08,
                  ),
                  CustomFormField(
                    onClic: (value) {
                      _email = value;
                    },
                    hint: "Enter your email",
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  CustomFormField(
                    onClic: (value) {
                      _password = value;
                    },
                    hint: "Enter your password",
                    icon: Icons.lock,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 10, .0, 0),
                    child: Row(
                      children: [
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            activeColor: kMainColor,
                            value: keepMeLoggedIn,
                            onChanged: (value) {
                              setState(() {
                                keepMeLoggedIn = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: Builder(
                      builder: (context) => FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          if (keepMeLoggedIn == true) {
                            keepMeLoggedInMethod();
                          }
                          validateUser(context);
                        },
                        color: Colors.black,
                        child: Text(
                          "login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account ?  ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUp.id);
                        },
                        child: Text(
                          ' Sign Up ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                              activeColor: kMainColor,
                              value: Provider.of<IsAsmin>(context).isAdmin,
                              onChanged: (value) {
                                if (Provider.of<IsAsmin>(context, listen: false)
                                        .isAdmin ==
                                    true) {
                                  Provider.of<IsAsmin>(context, listen: false)
                                      .isAdminValue(false);
                                } else {
                                  Provider.of<IsAsmin>(context, listen: false)
                                      .isAdminValue(true);
                                }
                              }),
                        ),
                        Text(
                          "Sign As Admin",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
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
    );
  }

  void validateUser(BuildContext context) async {
    final progressmode = Provider.of<ModelHud>(context, listen: false);
    if (_globalKey.currentState.validate()) {
      progressmode.changeIsLoadind(true);
      _globalKey.currentState.save();
      if (Provider.of<IsAsmin>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            await _user.signIn(_email.trim(), _password.trim());
            Navigator.pushNamed(context, AdminPage.id);
          } catch (e) {
            progressmode.changeIsLoadind(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          }
        }
      } else {
        try {
          await _user.signIn(_email, _password);
          Navigator.pushNamed(context, UserHomePage.id);
        } catch (e) {
          progressmode.changeIsLoadind(true);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
          ));
        }
      }
      progressmode.changeIsLoadind(false);
    }
  }

  keepMeLoggedInMethod() async {
    SharedPreferences _sharedPrefrences = await SharedPreferences.getInstance();
    _sharedPrefrences.setBool(kKeepMeLogedIn, keepMeLoggedIn);
  }
}
