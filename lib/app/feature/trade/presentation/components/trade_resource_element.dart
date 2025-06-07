import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class TradeResourceElement extends StatelessWidget {
  const TradeResourceElement({
    super.key,
    required this.resource,
    this.expanded = false,
  });

  final TradeResourceInventory resource;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final TradeBloc tradeBloc = context.read<TradeBloc>();
        if (tradeBloc.state.step == TradingStep.selectResource) {
          tradeBloc.add(SelectTradeResource(resource: resource));
        }
      },
      child: Container(
        width: expanded ? 130 : null,
        height: expanded ? 130 : null,
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
            if (expanded) H3(resource.tradeResource.name),
            Text(
              resource.tradeResource.icon,
              style: TextStyle(fontSize: expanded ? 42 : 32),
            ),
            if (expanded) H3('x${resource.storage}'),
            if (!expanded)
              LabelText(
                resource.tradeResource.name,
                textAlign: TextAlign.center,
                withBoarder: true,
              ),
          ],
        ),
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
