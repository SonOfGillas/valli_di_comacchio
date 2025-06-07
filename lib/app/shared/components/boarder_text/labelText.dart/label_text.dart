import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class LabelText extends StatelessWidget {
  const LabelText(this.text,
      {super.key, this.withBoarder = false, this.textAlign});

  final String text;
  final bool withBoarder;
  final TextAlign? textAlign;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      children: [
        if (withBoarder)
          Text(text,
              style: AppTextStyles.labelTextBorder, textAlign: textAlign),
        Text(text,
            style: (withBoarder)
                ? AppTextStyles.labelTextWithBoarder
                : AppTextStyles.labelText,
            textAlign: textAlign),
      ],
    );
  }
}
