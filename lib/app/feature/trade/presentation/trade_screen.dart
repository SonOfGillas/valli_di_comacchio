import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.palette_secondary,
      appBar: AppBar(
        title: H1OnPrimary(l10n.tradePageTitle),
      ),
      body: Column(
        children: [
          Image.asset(
            AppImages.rosario,
            height: 200,
          ),
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
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.background_white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.black_shadow_80,
                            width: 1.0,
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
                            const SizedBox(height: 8),
                            Text(
                              resource.tradeResource.name,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
