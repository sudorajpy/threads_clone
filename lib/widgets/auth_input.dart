import 'package:flutter/material.dart';
import 'package:threads_clone/utils/type_def.dart';

class AuthInput extends StatelessWidget {
  final String label, hintText;
  final ValidatorCallBack validator;
  final bool isPassword;
  final bool isUsername;
  final bool isUnique;
  ValueChanged<String>? onChanged;
  final TextEditingController controller;
  AuthInput(
      {super.key,
      required this.label,
      required this.hintText,
      this.isPassword = false,
      required this.controller,
      required this.validator,
      this.isUsername = false,
      this.onChanged,
      this.isUnique = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: isPassword,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffix: isUsername
            ? Icon(
                isUnique ? Icons.check : Icons.close,
                color: isUnique ? Colors.green : Colors.red,
              )
            : null,
        hintText: hintText,
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
