import 'package:chatapp/constans.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 80,
              width: 170,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('images/icons/cart.gif'),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                "",
                style: TextStyle(
                    fontFamily: 'myFont',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
