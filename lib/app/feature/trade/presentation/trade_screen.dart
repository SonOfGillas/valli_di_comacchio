import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
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
    return Scaffold(
      backgroundColor: AppColors.palette_secondary,
      appBar: ValliAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          NpcDisplayHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<TradeBloc, TradeState>(
                buildWhen: (previous, current) =>
                    previous.npc?.inventory != current.npc?.inventory,
                builder: (context, state) {
                  final inventory = state.npc?.inventory ?? [];
                  return GridView.builder(
                    itemCount: inventory.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
          ),
          DemandInfoGradient(),
        ],
      ),
    );
  }
}
