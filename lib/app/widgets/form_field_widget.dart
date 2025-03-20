import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_project/app/models/ProductManagement.dart';

class FormFieldWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool isRequired;
  final String? type;
  final int? maxLength;
  final int? minValue;
  final int? maxValue;
  final FocusNode? focusNode;


  const FormFieldWidget({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isRequired = false,
    this.type,
    this.maxLength,
    this.minValue,
    this.maxValue,
    this.focusNode,
  }) : super(key: key);

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  bool _isValid = false;
  String? _errorMessage;
  bool _hasFocus = false;
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());


  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_validateInput);
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_validateInput);
    _effectiveFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _hasFocus = _effectiveFocusNode.hasFocus;
    });
  }

  void _validateInput() {
    final value = widget.controller?.text;
    String? message;
    bool valid = true;

    if (widget.isRequired && (value == null || value.isEmpty)) {
      message = '${widget.labelText} is required';
      valid = false;
    } else if (widget.type == 'number' && value != null && value.isNotEmpty) {
      final parsedValue = int.tryParse(value);
      if (parsedValue == null) {
        message = 'Please enter a valid number for ${widget.labelText}';
        valid = false;
      } else {
        if (widget.minValue != null && parsedValue < widget.minValue!) {
          message = '${widget.labelText} must be at least ${widget.minValue}';
          valid = false;
        }
        if (widget.maxValue != null && parsedValue > widget.maxValue!) {
          message = '${widget.labelText} must be no more than ${widget.maxValue}';
          valid = false;
        }
      }
    } else if (widget.maxLength != null && (value?.length ?? 0) > widget.maxLength!) {
      message = '${widget.labelText} cannot be longer than ${widget.maxLength} characters';
      valid = false;
    }

    setState(() {
      _isValid = valid;
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: _getKeyboardType(widget.type),
      maxLength: widget.maxLength,
      focusNode: _effectiveFocusNode, // Assign the FocusNode
      decoration: InputDecoration(
        label: widget.isRequired
            ? Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
              TextSpan(text: ' ${widget.labelText}'),
            ],
          ),
        )
            : Text(widget.labelText),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder( // Style for when the field is focused
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: const OutlineInputBorder( // Style for when there is an error
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder( // Style for when focused and has error
          borderSide: BorderSide(color: Colors.red),
        ),
        suffixIcon: _buildValidationIcon(),
        errorText: _hasFocus ? _errorMessage : null, // Only show error message when focused
      ),
    );
  }

  Widget? _buildValidationIcon() {
    if (widget.controller?.text.isEmpty == true && !widget.isRequired) {
      return null;
    }
    if (_isValid) {
      return const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      );
    } else if (_errorMessage != null) {
      return const Icon(
        Icons.error_outline,
        color: Colors.red,
      );
    }
    return null;
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