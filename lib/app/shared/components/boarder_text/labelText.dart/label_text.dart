import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class LabelText extends StatelessWidget {
  const LabelText(this.text,
      {super.key,
      this.withBoarder = true,
      this.textAlign,
      this.enableEndEllipsis = false});

  final String text;
  final bool withBoarder;
  final TextAlign? textAlign;
  final bool enableEndEllipsis;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      children: [
        if (withBoarder)
          Text(text,
              overflow: enableEndEllipsis ? TextOverflow.ellipsis : null,
              style: AppTextStyles.labelTextBorder,
              maxLines: enableEndEllipsis ? 1 : null,
              textAlign: textAlign),
        Text(text,
            overflow: enableEndEllipsis ? TextOverflow.ellipsis : null,
            style: (withBoarder)
                ? AppTextStyles.labelTextWithBoarder
                : AppTextStyles.labelText,
            textAlign: textAlign,
            maxLines: enableEndEllipsis ? 1 : null),
      ],
    );
  }
}
