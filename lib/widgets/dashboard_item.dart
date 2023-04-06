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
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        padding: EdgeInsets.all(height * 0.01),
        margin: EdgeInsets.only(
            left: height * 0.005, right: height * 0.005, bottom: height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(1, 5),
            )
          ],
          // image: DecorationImage(
          //   // fit: BoxFit.fill,
          //   image: AssetImage('assets/icons/$image.png'),
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/$image.png',
              height: height * 0.13,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
