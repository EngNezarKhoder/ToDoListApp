import 'package:flutter/material.dart';

class MyMaterialButton extends StatefulWidget {
  const MyMaterialButton(
      {super.key,
      required this.onPressed,
      required this.height,
      required this.minWidth,
      required this.color,
      required this.title});
  final void Function()? onPressed;
  final double height;
  final double minWidth;
  final Color color;
  final String title;

  @override
  State<MyMaterialButton> createState() => _MyMaterialButtonState();
}

class _MyMaterialButtonState extends State<MyMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      height: widget.height,
      minWidth: widget.minWidth,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      color: widget.color,
      textColor: Colors.white,
      child: Text(
        widget.title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}


