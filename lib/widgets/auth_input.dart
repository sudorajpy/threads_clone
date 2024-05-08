import 'package:flutter/material.dart';
import 'package:threads_clone/utils/type_def.dart';

class AuthInput extends StatelessWidget {
  final String label, hintText;
  final ValidatorCallBack validator;
  final bool isPassword;
  final TextEditingController controller;
  const AuthInput({super.key, required this.label, required this.hintText, this.isPassword =false, required this.controller, required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
