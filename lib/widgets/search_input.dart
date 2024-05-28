import 'package:flutter/material.dart';
import 'package:threads_clone/utils/type_def.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final InputCallBack callBack;
  const SearchInput({super.key, required this.controller, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onChanged: callBack,
        decoration: InputDecoration(
          hintText: 'Search User',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          filled: true,
          fillColor: Color(0xff242424),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            // borderSide: BorderSide(color: Color(0xff242424),
            // ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            // borderSide: BorderSide(color: Colors.blue),
          ),
        ));
  }
}
