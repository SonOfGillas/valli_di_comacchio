import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
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
            ),
            if (state.selectedResource != null)
              Row(
                children: [
                  //H3('${state.npc?.name} possiede:'),
                  TradeResourceElement(
                      resource: state.selectedResource!, expanded: true),
                  //H3('x ${state.selectedResource!.storage}'),
                ],
              )
          ],
        ));
      },
    );
  }
}
