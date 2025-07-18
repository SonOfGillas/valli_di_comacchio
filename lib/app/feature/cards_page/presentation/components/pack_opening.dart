import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_inspection_overlay.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_widget.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/revealed_card_widget.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/revealed_cards_area.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class PackOpeningPage extends StatefulWidget {
  const PackOpeningPage({
    super.key,
    required this.pack,
    required this.onCardRevealed,
    required this.onClose,
  });

  final CardPack pack;
  final Function(CollectibleCard) onCardRevealed;
  final VoidCallback onClose;

  @override
  State<PackOpeningPage> createState() => _PackOpeningPageState();
}

class _PackOpeningPageState extends State<PackOpeningPage> {
  @override
  void initState() {
    super.initState();
    // Initialize pack opening in the cubit
    context.read<CardCubit>().startPackOpening(widget.pack);
  }

  void _handlePackTap(CardState state) {
    final cubit = context.read<CardCubit>();

    if (state.packOpeningStage == PackOpeningStage.initial) {
      cubit.startRevealingCards();
    } else if (!state.isRevealingCard && state.remainingCards.isNotEmpty) {
      cubit.revealNextCard();
    } else if (state.remainingCards.isEmpty) {
      widget.onClose();
    }
  }

  void _handleCardTap() {
    final cubit = context.read<CardCubit>();
    final currentCard = cubit.state.currentRevealedCard;

    if (currentCard != null) {
      // Trigger the card revealed callback before completing the reveal
      widget.onCardRevealed(currentCard);
      // Complete the card reveal animation and move to revealed cards area
      cubit.completeCardReveal();
    }
  }

  void _handleAnimationComplete() {
    final cubit = context.read<CardCubit>();
    final currentCard = cubit.state.currentRevealedCard;

    if (currentCard != null) {
      // Auto-trigger the card revealed callback when animation completes naturally
      widget.onCardRevealed(currentCard);
      // Auto-complete the card reveal after the timer expires
      cubit.completeCardReveal();
    }
  }

  void _handleInspectCard(CollectibleCard card) {
    context.read<CardCubit>().inspectCard(card);
  }

  void _handleCloseInspection() {
    context.read<CardCubit>().closeCardInspection();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCubit, CardState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Main pack opening interface
            _buildMainInterface(state),

            // Card inspection overlay
            if (state.selectedCardForInspection != null)
              CardInspectionOverlay(
                card: state.selectedCardForInspection!,
                onClose: _handleCloseInspection,
              ),
          ],
        );
      },
    );
  }

  Widget _buildMainInterface(CardState state) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.palette_secondary,
                AppColors.palette_tertiary,
              ],
            ),
          ),
        ),

        Column(
          children: [
            // Header with status
            _buildHeader(state),

            // Pack area
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pack widget
                    PackWidget(
                      state: state,
                      onTap: () => _handlePackTap(state),
                    ),

                    // Revealed card animation
                    if (state.currentRevealedCard != null)
                      RevealedCardWidget(
                        card: state.currentRevealedCard!,
                        state: state,
                        onTap: _handleCardTap,
                        isNewCard: state.newCardsInTheLastPack.any(
                          (c) => c.id == state.currentRevealedCard!.id,
                        ),
                        onAnimationComplete: _handleAnimationComplete,
                      ),
                  ],
                ),
              ),
            ),

            // Revealed cards area
            RevealedCardsArea(
              state: state,
              onCardTap: _handleInspectCard,
              newCardsInPack: state.newCardsInTheLastPack,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(CardState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.palette_primary,
              size: 30,
            ),
            onPressed: widget.onClose,
          ),
          H3(
            state.remainingCards.isEmpty
                ? 'Il Pacchetto è vuoto!'
                : 'Carte rimanenti: ${state.remainingCards.length}',
          ),
          Container(width: 40), // Fixed width for alignment
        ],
      ),
    );
  }
}
