import 'package:flutter/material.dart';

void showModal({required BuildContext context, required Widget child}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    ),
  );
}
