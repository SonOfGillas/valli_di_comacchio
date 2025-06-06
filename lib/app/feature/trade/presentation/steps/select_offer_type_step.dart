import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/retro_gold_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';

class SelectOfferTypeStep extends StatelessWidget {
  const SelectOfferTypeStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeBloc, TradeState>(
      builder: (context, state) {
        return Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RetroGoldButton(
                    label: 'COMPRA',
                    onPressed: () {
                      context
                          .read<TradeBloc>()
                          .add(SelectOfferType(offerType: OfferType.buy));
                    }),
                RetroGoldButton(
                    label: 'VENDI',
                    onPressed: () {
                      context
                          .read<TradeBloc>()
                          .add(SelectOfferType(offerType: OfferType.sell));
                    }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //H3('${state.npc?.name} possiede:'),
                  TradeResourceElement(
                      resource: state.selectedResource!, expanded: true),
                  //H3('x ${state.selectedResource!.storage}'),
                ],
              ),
            )
          ],
        ));
      },
    );
  }
}
