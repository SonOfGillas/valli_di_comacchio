import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class H1 extends StatelessWidget {
  const H1(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text, style: AppTextStyles.h1OnPrimaryBorder),
        Text(text, style: AppTextStyles.h1OnPrimary),
      ],
    );
  }
}
