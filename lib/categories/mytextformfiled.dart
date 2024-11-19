import 'package:flutter/material.dart';

class MyTextFormFiled extends StatefulWidget {
  const MyTextFormFiled({super.key, required this.label, required this.controller, required this.validator});
  final String? label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  State<MyTextFormFiled> createState() => _MyTextFormFiledState();
}

class _MyTextFormFiledState extends State<MyTextFormFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.label,
        labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100))),
      ),
    );
  }
}
