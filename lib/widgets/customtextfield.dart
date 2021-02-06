import 'package:chatapp/constans.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onClic;
  CustomFormField(
      {@required this.onClic, @required this.icon, @required this.hint});
  String _messageError() {
    switch (hint) {
      case "Enter your full name ":
        return " Empty Name !!! ";
      case "Enter your email":
        return " Empty Email ";
      case "Enter your password":
        return " Empty Password ";
      case "Enter your phone number":
        return "Empty Phone Number";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        onSaved: onClic,
        obscureText: hint == "Enter your password" ? true : false,
        validator: (value) {
          if (value.isEmpty) {
            return _messageError();
          }
        },
        cursorColor: kMainColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey),
          filled: true,
          fillColor: Colors.white70,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              5,
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              5,
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              5,
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
