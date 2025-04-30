import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/spinner/spinner_style.dart';

class AppSpinner extends StatelessWidget {
  ///App standard spinner
  const AppSpinner({
    super.key,
    this.size = AppSpinnerSize.s,
    this.variant = AppSpinnerVariant.blue,
  });

  ///OPTIONAL. Changes spinner's size. Default: AppSpinnerSize.s
  final AppSpinnerSize size;

  ///OPTIONAL. Changes spinner's color. Default: AppSpinnerVariant.blue
  final AppSpinnerVariant variant;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size.spinnerSize,
        width: size.spinnerSize,
        child: CircularProgressIndicator(
          color: variant == AppSpinnerVariant.blue
              ? AppSpinnerColors.appSpinner
              : AppSpinnerColors.appSpinnerWhite,
        ),
      ),
    );
  }
}
