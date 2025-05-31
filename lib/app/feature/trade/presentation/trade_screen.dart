import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
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
                      return _TradeResourceGridElment(resource: resource);
                    },
                  );
                },
              ),
            ),
          ),
          _InfoGradient(),
        ],
      ),
    );
  }
}

class _InfoGradient extends StatelessWidget {
  const _InfoGradient();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SizedBox(
        height: 32,
        child: Stack(
          children: [
            // Gradient bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppColors.shade_green_100,
                    AppColors.shade_green_90,
                    AppColors.shade_green_80,
                    AppColors.shade_green_70,
                    AppColors.shade_green_60,
                    AppColors.shade_green_50,
                    AppColors.shade_green_40,
                    AppColors.shade_green_30,
                    AppColors.shade_green_20,
                    AppColors.shade_green_10,
                    AppColors.shades_white_75,
                    AppColors.shade_red_10,
                    AppColors.shade_red_20,
                    AppColors.shade_red_30,
                    AppColors.shade_red_40,
                    AppColors.shade_red_50,
                    AppColors.shade_red_60,
                    AppColors.shade_red_70,
                    AppColors.shade_red_80,
                    AppColors.shade_red_90,
                    AppColors.shade_red_100,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Texts
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'good to buy',
                  style: TextStyle(
                    color: AppColors.palette_primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'good to sell',
                  style: TextStyle(
                    color: AppColors.palette_primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeResourceGridElment extends StatelessWidget {
  const _TradeResourceGridElment({
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
          const SizedBox(height: 4),
          Text(
            resource.tradeResource.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
