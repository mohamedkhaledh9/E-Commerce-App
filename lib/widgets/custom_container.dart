import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget navigateScreen;

  CustomContainer({this.icon, this.text, this.navigateScreen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigateScreen));
      },
      child: Opacity(
        opacity: .8,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          height: 120,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.purple),
        ),
      ),
    );
  }
}
