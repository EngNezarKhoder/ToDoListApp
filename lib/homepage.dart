import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/login.dart';
import 'package:fluttercourse/auth/register.dart';
import 'package:fluttercourse/categories/logo.dart';
import 'package:fluttercourse/categories/mybutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const MyLogo(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "TO DO LIST LOGO",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              "SLODAN HERE",
              style: TextStyle(fontSize: 10, color: Colors.purple),
            ),
            const SizedBox(
              height: 70,
            ),
            MyMaterialButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Register()));
                },
                height: 40,
                minWidth: 250,
                color: const Color.fromARGB(255, 46, 99, 242),
                title: "Register"),
            const SizedBox(
              height: 10,
            ),
            MyMaterialButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignIn()));
                },
                height: 40,
                minWidth: 250,
                color: const Color.fromARGB(255, 201, 67, 163),
                title: "Sign In"),
          ],
        ),
    );
  }
}
