import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  bool obscureText;
  int maxLines;
  bool enabled;
  final IconData iconData;
  final String hintText;
  final String labelText;
  final String? Function(String?) validator;

  CustomTextFormField({
    Key? key,
    this.obscureText = false,
    this.maxLines = 20,
    this.enabled = true,
    required this.controller,
    required this.keyboardType,
    required this.iconData,
    required this.hintText,
    required this.labelText,
    required this.validator,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: (){
        FocusScope.of(context).nextFocus();
      },
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      enabled: widget.enabled,
      style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      obscureText: widget.obscureText,
      minLines: 1,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.grey.shade800, style: BorderStyle.solid, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.grey, style: BorderStyle.solid, width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.grey, style: BorderStyle.solid, width: 1),
        ),
        prefixIcon:
            Icon(widget.iconData, color: Theme.of(context).iconTheme.color),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        suffixIcon: widget.iconData == Icons.lock_outline_sharp
            ? IconButton(
                icon: Icon(
                  widget.obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
