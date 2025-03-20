import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_project/app/models/ProductManagement.dart';

class FormFieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool isRequired;
  final String? type;
  final int? maxLength;
  final int? minValue;
  final int? maxValue;

  const FormFieldWidget({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isRequired = false,
    this.type,
    this.maxLength,
    this.minValue,
    this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: _getKeyboardType(type),
      maxLength: maxLength,
      decoration: InputDecoration(
        label: isRequired
            ? Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(text: ' $labelText'),
                  ],
                ),
              )
            : Text(labelText),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '$labelText is required';
        }
        if (type == 'number') {
          final parsedValue = int.tryParse(value ?? '');
          if (parsedValue == null) {
            return 'Please enter a valid number for $labelText';
          }
          if (minValue != null && parsedValue < minValue!) {
            return '$labelText must be at least $minValue';
          }
          if (maxValue != null && parsedValue > maxValue!) {
            return '$labelText must be no more than $maxValue';
          }
        }
        if (maxLength != null && (value?.length ?? 0) > maxLength!) {
          return '$labelText cannot be longer than $maxLength characters';
        }
        return null;
      },
    );
  }

  TextInputType _getKeyboardType(String? type) {
    switch (type) {
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
