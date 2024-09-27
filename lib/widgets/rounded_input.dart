import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {
  final String hintText;
  final Icon? prefixIcon; // Make prefixIcon nullable
  final Widget? suffixIcon;
  final String? labelText; // Make labelText nullable
  final TextEditingController controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const RoundedInput({
    super.key,
    required this.hintText,
    this.prefixIcon, // Remove required
    this.suffixIcon,
    this.labelText, // Remove required
    required this.controller,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: TextFormField(
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: prefixIcon, // Use prefixIcon directly
          labelText: labelText,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: () {
                    onChanged?.call(controller.text);
                  },
                  icon: suffixIcon!,
                )
              : null,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        controller: controller,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
