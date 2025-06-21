import 'dart:async';
import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield.dart';

class DebouncedTextField extends StatefulWidget {
  final Duration debounceDuration;
  final void Function(String)? onDebouncedChange;
  final AppTextField textField;

  const DebouncedTextField({
    super.key,
    required this.textField,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.onDebouncedChange,
  });

  @override
  State<DebouncedTextField> createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onDebouncedChange?.call(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      // Copy all properties from widget.textField except onChange
      key: widget.textField.key,
      placeHolder: widget.textField.placeHolder,
      type: widget.textField.type,
      labelPosition: widget.textField.labelPosition,
      labelStyle: widget.textField.labelStyle,
      variant: widget.textField.variant,
      disabled: widget.textField.disabled,
      readOnly: widget.textField.readOnly,
      label: widget.textField.label,
      controller: widget.textField.controller,
      rightIcon: widget.textField.rightIcon,
      leftIcon: widget.textField.leftIcon,
      leftIconColor: widget.textField.leftIconColor,
      leftIconPadding: widget.textField.leftIconPadding,
      rightIconColor: widget.textField.rightIconColor,
      rightIconPadding: widget.textField.rightIconPadding,
      onRightIconTap: widget.textField.onRightIconTap,
      errorMessage: widget.textField.errorMessage,
      onChange: _onChanged,
      onSubmit: widget.textField.onSubmit,
      height: widget.textField.height,
      placeholderStyle: widget.textField.placeholderStyle,
      maxLength: widget.textField.maxLength,
      focusNode: widget.textField.focusNode,
    );
  }
}
