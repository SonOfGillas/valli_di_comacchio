import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/alert/app_alert_style.dart';

abstract class AppAlert extends StatelessWidget {
  const AppAlert({super.key});

  ///App standard alert
  ///size OPTIONAL. Changes alert's size. Default: AppAlertSize.short
  ///variant OPTIONAL. Changes alert's style. Default: AppAlertVariant.info
  ///showCloseIcon OPTIONAL. Shows the close icon. Default: true
  ///showVariantIcon OPTIONAL. Shows the variant icon. Default: true
  ///callToActionText OPTIONAL. The text shown for the call to action.
  ///text REQUIRED. The text shown in the alert.
  ///context REQUIRED. The context to pass.
  static void show(
    BuildContext context,
    String text, {
    AppAlertVariant variant = AppAlertVariant.info,
    AppAlertSize size = AppAlertSize.long,
    AppAlertAction? callToAction,
    Duration duration = const Duration(milliseconds: 5000),
    bool showVariantIcon = true,
    bool showCloseIcon = true,
  }) {
    Color bgColor;
    Icon variantIcon;
    switch (variant) {
      case AppAlertVariant.info:
        bgColor = AppAlertColors.infoAlertBackground;
        variantIcon = const Icon(
          Icons.info,
          color: AppAlertColors.infoAlertIcon,
        );
        break;
      case AppAlertVariant.warning:
        bgColor = AppAlertColors.warningAlertBackground;
        variantIcon = const Icon(
          Icons.warning_rounded,
          color: AppAlertColors.warningAlertIcon,
        );
        break;
      case AppAlertVariant.success:
        bgColor = AppAlertColors.successAlertBackground;
        variantIcon = const Icon(
          Icons.done_rounded,
          color: AppAlertColors.successAlertIcon,
        );
        break;
      case AppAlertVariant.error:
        bgColor = AppAlertColors.errorAlertBackground;
        variantIcon = const Icon(
          Icons.error,
          color: AppAlertColors.errorAlertIcon,
        );
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: callToAction == null
            ? null
            : SnackBarAction(
                label: callToAction.label,
                onPressed: callToAction.onPressed,
              ),
        content: showVariantIcon
            ? Row(
                children: [
                  variantIcon,
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        text,
                        style: const TextStyle(color: AppAlertColors.alertFont),
                        maxLines: size == AppAlertSize.short ? 1 : null,
                        //overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        text,
                        style: const TextStyle(color: AppAlertColors.alertFont),
                        maxLines: size == AppAlertSize.short ? 1 : 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
        duration: duration,
        width:
            MediaQuery.of(context).size.width * 0.90, // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: bgColor,
        showCloseIcon: showCloseIcon,
        closeIconColor: AppAlertColors.alertFont,
      ),
    );
  }

  static void hideCurrent(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

class AppAlertAction {
  AppAlertAction({
    required this.label,
    required this.onPressed,
  });

  /// The button label.
  final String label;

  /// The callback to be called when the action's button is pressed.
  final VoidCallback onPressed;
}
