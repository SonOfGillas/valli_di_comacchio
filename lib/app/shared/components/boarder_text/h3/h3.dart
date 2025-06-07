import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class H3 extends StatelessWidget {
  const H3(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text, style: AppTextStyles.h3Border),
        Text(text, style: AppTextStyles.h3WithBoarder),
      ],
    );
  }
}
