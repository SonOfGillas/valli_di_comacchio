import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';

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
                return TradeResourceElement(resource: resource);
              },
            );
          },
        ),
      ),
    );
  }
}
