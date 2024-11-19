import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 246, 247, 255),
            borderRadius: BorderRadius.circular(100)),
        child: Image.asset(
          "images/dating-app-logo-example.jpg",
          height: 100,
        ),
      ),
    );
  }
}
