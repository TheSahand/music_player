import 'package:flutter/material.dart';

class MyBoxDecoration extends StatelessWidget {
  MyBoxDecoration(
      {super.key, required this.innerPadding, required this.imageUrl});
  double innerPadding;
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(innerPadding),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                offset: const Offset(-4, 4),
                blurRadius: 6,
                color: const Color(0xff000000).withOpacity(0.36)),
            BoxShadow(
                offset: const Offset(3, -3),
                blurRadius: 3,
                color: const Color(0xffFFFFFF).withOpacity(0.07))
          ],
          gradient: const LinearGradient(
              colors: [Color(0xff212222), Color(0xff3F4144)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: Image(image: AssetImage(imageUrl)),
    );
  }
}
