import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_buy_modal.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_courosel.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class PackCarouselScreen extends StatelessWidget {
  const PackCarouselScreen({
    super.key,
    required this.onBack,
    required this.onPackSelected,
  });

  final VoidCallback onBack;
  final Function(CardPack) onPackSelected;

  void _onPackSelected(CardPack pack, BuildContext context) {
    final cardCubit = context.read<CardCubit>();
    final userHaveEnoughCoins = cardCubit.userHasEnoughCoins;

    _showPackCostModal(context, pack, userHaveEnoughCoins);
  }

  void _showPackCostModal(
      BuildContext context, CardPack pack, bool userHaveEnoughCoins) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return buyPackModal(
          context: context,
          userHaveEnoughCoins: userHaveEnoughCoins,
          onOpenPack: () {
            onPackSelected(pack);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.palette_secondary,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              const H1(
                'Scegli un pacchetto',
              ),
              const SizedBox(height: 40),
              Expanded(
                child: PackCarousel(
                  onPackSelected: (cardPack) =>
                      _onPackSelected(cardPack, context),
                ),
              ),
            ],
          ),
          // Back button
          Positioned(
            top: 12,
            left: 12,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.palette_primary,
                size: 30,
              ),
              onPressed: onBack,
            ),
          ),
        ],
      ),
    );
  }
}
