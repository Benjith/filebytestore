import 'package:filebytestore/utils/color_resources.dart';
import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({super.key, this.onChange, required this.hintText});
  final Function(String)? onChange;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(
              left: 0,
            ),
            child: const Icon(Icons.search),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorResources.placeHolder),
          filled: true,
          fillColor: ColorResources.placeHolder,
          border: InputBorder.none),
    );
  }
}
