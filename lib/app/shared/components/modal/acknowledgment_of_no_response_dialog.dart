import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/modal/app_modal.dart';
import 'package:valli_di_comacchio/app/shared/core/dialog/show_modal.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';

void showAcknowledgementOfNoResponseDialog(
  BuildContext context,
  void Function() onButtonPressed,
) {
  final l10n = context.l10n;
  showModal(
    context: context,
    child: AppModal(
      title: l10n.acknowledgementOfNoResponseDialogTitle,
      message: l10n.acknowledgementOfNoResponseDialogMessage,
      buttonText: l10n.commonExit,
      onButtonPressed: onButtonPressed,
      showCloseButton: true,
    ),
  );
}
