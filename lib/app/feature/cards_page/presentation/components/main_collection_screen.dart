import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_collection_grid.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/collection_stats_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class MainCollectionScreen extends StatelessWidget {
  const MainCollectionScreen({
    super.key,
    required this.onCardTap,
    required this.onOpenNewPack,
    required this.selectedCard,
    required this.cardInspectionOverlay,
  });

  final Function(CollectibleCard) onCardTap;
  final VoidCallback onOpenNewPack;
  final CollectibleCard? selectedCard;
  final Widget? cardInspectionOverlay;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCubit, CardState>(
      buildWhen: (previous, current) =>
          previous.userCards.length != current.userCards.length ||
          previous.newCardsInTheLastPack != current.newCardsInTheLastPack,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.palette_secondary,
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stats bar
                  const CollectionStatsBar(),

                  // Card collection
                  Expanded(
                    child: CardCollectionGrid(
                      onCardTap: onCardTap,
                    ),
                  ),
                ],
              ),

              // Card inspection overlay
              if (cardInspectionOverlay != null) cardInspectionOverlay!,
            ],
          ),
          floatingActionButton: selectedCard == null
              ? FloatingActionButton.extended(
                  onPressed: onOpenNewPack,
                  backgroundColor: Colors.amber,
                  label: const Text(
                    'APRI UN PACCHETTO',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
