import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String? Function(String?) validator;
  Function() sendOnPressed;

  MyTextField({
    super.key,
    required this.controller,
    required this.validator,
    required this.sendOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: "Enter topic",
        suffixIcon: IconButton(
          onPressed: sendOnPressed,
          icon: const Icon(
            Icons.send,
            color: Colors.amber,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
