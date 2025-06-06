import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/demand_info_gradient.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_grid_element.dart';
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

class SelectResourceStep extends StatelessWidget {
  const SelectResourceStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TradeBloc, TradeState>(
          buildWhen: (previous, current) =>
              previous.npc?.inventory != current.npc?.inventory,
          builder: (context, state) {
            final inventory = state.npc?.inventory ?? [];
            return GridView.builder(
              itemCount: inventory.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final resource = inventory[index];
                return TradeResourceGridElement(resource: resource);
              },
            );
          },
        ),
      ),
    );
  }
}

class SelectOfferTypeStep extends StatelessWidget {
  const SelectOfferTypeStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                context
                    .read<TradeBloc>()
                    .add(SelectOfferType(offerType: OfferType.buy));
              },
              child: Text('Buy'),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<TradeBloc>()
                    .add(SelectOfferType(offerType: OfferType.sell));
              },
              child: Text('Sell'),
            ),
          ],
        )
      ],
    ));
  }
}

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
