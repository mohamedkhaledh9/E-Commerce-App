import 'package:chatapp/provider/progress_hud.dart';
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
  String _email, _password;
  final _user = Auth();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              AppLogo(),
              SizedBox(
                height: height * .1,
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
                height: height * .1,
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
                          debugPrint("your entered password is : $_password");
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
                    onTap: () {},
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
        ),
      ),
    );
  }
}
