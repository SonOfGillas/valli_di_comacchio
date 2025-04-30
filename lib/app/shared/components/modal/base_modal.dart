import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class BaseModal extends StatelessWidget {
  const BaseModal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.background_black.withValues(alpha: 0.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: child,
      ),
    );
  }
}

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    required this.child,
    this.useDefaultPadding = true,
  });

  final Widget child;
  final bool useDefaultPadding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      //insetPadding: const EdgeInsets.all(Spacing.xxl),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.background_dark_gray),
          color: AppColors.background_dark_gray,
        ),
        //padding: useDefaultPadding ? const EdgeInsets.all(Spacing.xl) : null,
        child: child,
      ),
    );
  }
}

void closeModal(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).pop();
