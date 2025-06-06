import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class TradeResourceGridElement extends StatelessWidget {
  const TradeResourceGridElement({
    super.key,
    required this.resource,
  });

  final TradeResourceInventory resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.background_white,
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black_shadow_80,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resource.tradeResource.icon,
            style: const TextStyle(fontSize: 32),
          ),
          LabelText(resource.tradeResource.name, textAlign: TextAlign.center),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    final demandNormalized = resource.demandNormalized;
    if (demandNormalized < -0.9) {
      return AppColors.shade_green_100;
    } else if (demandNormalized < -0.8) {
      return AppColors.shade_green_90;
    } else if (demandNormalized < -0.7) {
      return AppColors.shade_green_80;
    } else if (demandNormalized < -0.6) {
      return AppColors.shade_green_70;
    } else if (demandNormalized < -0.5) {
      return AppColors.shade_green_60;
    } else if (demandNormalized < -0.4) {
      return AppColors.shade_green_50;
    } else if (demandNormalized < -0.3) {
      return AppColors.shade_green_40;
    } else if (demandNormalized < -0.2) {
      return AppColors.shade_green_30;
    } else if (demandNormalized < 0.1) {
      return AppColors.shade_green_20;
    } else if (demandNormalized < 0) {
      return AppColors.shade_green_10;
    } else if (demandNormalized == 0) {
      return AppColors.shades_white_75;
    } else if (demandNormalized < 0.1) {
      return AppColors.shade_red_10;
    } else if (demandNormalized < 0.2) {
      return AppColors.shade_red_20;
    } else if (demandNormalized < 0.3) {
      return AppColors.shade_red_30;
    } else if (demandNormalized < 0.4) {
      return AppColors.shade_red_40;
    } else if (demandNormalized < 0.5) {
      return AppColors.shade_red_50;
    } else if (demandNormalized < 0.6) {
      return AppColors.shade_red_60;
    } else if (demandNormalized < 0.7) {
      return AppColors.shade_red_70;
    } else if (demandNormalized < 0.8) {
      return AppColors.shade_red_80;
    } else if (demandNormalized < 0.9) {
      return AppColors.shade_red_90;
    } else {
      return AppColors.shade_red_100;
    }
  }
}
