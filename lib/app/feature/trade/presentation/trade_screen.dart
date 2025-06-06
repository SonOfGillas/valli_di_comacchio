import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/demand_info_gradient.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_grid_element.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

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

class ValliAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ValliAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.background_white),
          onPressed: () => context.go(RoutesPaths.home)),
      title: H1OnPrimary(l10n.tradePageTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.money,
                width: 34,
                height: 34,
                colorFilter: ColorFilter.mode(
                  AppColors.background_white,
                  BlendMode.srcIn,
                ),
              ),
              // TODO: Replace with actual wealth value
              LabelText('1023', withBoarder: true),
            ],
          ),
        ),
      ],
    );
  }
}
