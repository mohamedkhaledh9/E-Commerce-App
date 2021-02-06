import 'package:chatapp/provider/progress_hud.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/customtextfield.dart';
import 'package:chatapp/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../constans.dart';

class SignUp extends StatelessWidget {
  static String id = 'SignUpScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _email, _password, phonNumber;

  final _user = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          "Register Page",
          style: TextStyle(fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
      ),
      backgroundColor: kMainColor,
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
                  SizedBox(
                    height: height * .1,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Welcome To My Store : )",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ]),
                  SizedBox(
                    height: height * .06,
                  ),
                  CustomFormField(
                    hint: "Enter your full name ",
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  CustomFormField(
                    onClic: (value) {
                      _email = value;
                    },
                    hint: "Enter your email",
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  CustomFormField(
                    onClic: (value) {
                      _password = value;
                    },
                    hint: "Enter your password",
                    icon: Icons.lock,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  CustomFormField(
                    hint: "Enter your phone number",
                    icon: Icons.phone,
                    onClic: (value) {
                      phonNumber = value;
                    },
                  ),
                  SizedBox(
                    height: height * .07,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: Builder(
                      builder: (context) => FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () async {
                          final progresshud =
                              Provider.of<ModelHud>(context, listen: false);
                          progresshud.changeIsLoadind(true);
                          if (_globalKey.currentState.validate()) {
                            _globalKey.currentState.save();
                            try {
                              final userData =
                                  await _user.signUp(_email, _password);
                              progresshud.changeIsLoadind(false);
                              debugPrint("your entered email is : $_email");
                              debugPrint(
                                  "your entered password is : $_password");
                            } catch (e) {
                              progresshud.changeIsLoadind(false);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(e.message),
                              ));
                            }
                          }
                          progresshud.changeIsLoadind(false);
                        },
                        color: Colors.black,
                        child: Text(
                          " Sign Up ",
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
                        'Do have an account ?  ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          ' Login ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
