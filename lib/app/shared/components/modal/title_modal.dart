import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/modal/app_modal.dart';
import 'package:valli_di_comacchio/app/shared/core/dialog/show_modal.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';

void titleInfoDialog(
  BuildContext context,
  String title,
) {
  final l10n = context.l10n;
  showModal(
    context: context,
    child: AppModal(
      title: l10n.commonTitle,
      message: title,
      buttonText: l10n.commonExit,
      onButtonPressed: () {},
      showCloseButton: true,
    ),
  );
}
