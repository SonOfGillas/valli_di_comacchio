import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class H2 extends StatelessWidget {
  const H2(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text, style: AppTextStyles.h2Boarder),
        Text(text, style: AppTextStyles.h2WithBorder),
      ],
    );
  }
}
