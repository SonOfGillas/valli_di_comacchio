import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class SetPriceStep extends StatelessWidget {
  const SetPriceStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'Set Price Step',
          style: TextStyle(color: AppColors.background_white),
        ),
      ),
    );
  }
}
