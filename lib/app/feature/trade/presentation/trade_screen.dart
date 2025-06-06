import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/demand_info_gradient.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/steps/select_offer_type_step.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/steps/select_resource_step.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/steps/set_price_step.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeBloc, TradeState>(
      buildWhen: (previous, current) =>
          previous.step != current.step ||
          previous.npc?.inventory != current.npc?.inventory,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.palette_secondary,
          appBar: ValliAppBar(
            onBackPressed: () {
              if (state.step == TradingStep.selectOfferType ||
                  state.step == TradingStep.setPrice) {
                context.read<TradeBloc>().add(GoBack());
              } else {
                context.pop();
              }
            },
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NpcDisplayHeader(),
              if (state.step == TradingStep.selectResource)
                SelectResourceStep(),
              if (state.step == TradingStep.selectOfferType)
                SelectOfferTypeStep(),
              if (state.step == TradingStep.setPrice) SetPriceStep(),
              DemandInfoGradient(),
            ],
          ),
        );
      },
    );
  }
}
