import 'package:flutter/material.dart';

class DashBoardItem extends StatelessWidget {
  const DashBoardItem({
    super.key,
    required this.text,
    required this.image,
    this.onTap,
  });

  final String text;
  final String image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final hight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    // fit: BoxFit.fill,
                    image: AssetImage('assets/icons/$image.png'))),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: hight * 0.18,
                )),
          ),
          Text(text),
        ],
      ),
    );
  }
}
