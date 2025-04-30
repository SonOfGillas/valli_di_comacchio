import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class TextWithLinks extends StatelessWidget {
  const TextWithLinks({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style ?? AppTextStyles.label,
        children: _buildTextWithLinks(text),
      ),
    );
  }

  static List<TextSpan> _buildTextWithLinks(
    String text,
  ) {
    final textSpans = <TextSpan>[];
    final words = text.split(' ');

    for (final word in words) {
      if (word.startsWith('http')) {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: AppColors.palette_accent,
              decoration: TextDecoration.underline,
              height: 1.5,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse(word));
              },
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              height: 1.5,
            ),
          ),
        );
      }
    }

    return textSpans;
  }
}
