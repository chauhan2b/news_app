import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.title,
    this.obscureText = false,
    this.keyboardType,
    required this.name,
    this.validator,
  });
  final TextEditingController controller;
  final String title;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String name;
  final FormFieldValidator<String?>? validator;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text(title),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
