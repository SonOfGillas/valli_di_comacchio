import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_opening.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_carousel_screen.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/main_collection_screen.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_detail.dart';

class CardPageScreen extends StatefulWidget {
  const CardPageScreen({super.key});

  @override
  State<CardPageScreen> createState() => _CardPageScreenState();
}

class _CardPageScreenState extends State<CardPageScreen>
    with SingleTickerProviderStateMixin {
  // Selected card for inspection
  CollectibleCard? _selectedCard;

  // Controller for card inspection animation
  late AnimationController _inspectController;
  late Animation<double> _inspectAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCardInspectionAnimation();
  }

  void _initializeCardInspectionAnimation() {
    _inspectController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _inspectAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _inspectController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _inspectController.dispose();
    super.dispose();
  }

  // Handle card inspection
  void _inspectCard(CollectibleCard card) {
    setState(() {
      _selectedCard = card;
    });
    _inspectController.reset();
    _inspectController.forward();
  }

  // Close card inspection
  void _closeInspection() {
    _inspectController.reverse().then((_) {
      setState(() {
        _selectedCard = null;
      });
    });
  }

  // Handle pack selection and opening
  void _onPackSelected(CardPack pack) {
    final cardCubit = context.read<CardCubit>();
    cardCubit.openAPack(pack);
    cardCubit.showPackOpening(pack);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCubit, CardState>(
      builder: (context, state) {
        switch (state.currentView) {
          case CardPageView.packCarousel:
            return PackCarouselScreen(
              onBack: () => context.read<CardCubit>().showMainCollection(),
              onPackSelected: _onPackSelected,
            );

          case CardPageView.packOpening:
            if (state.selectedPack == null) {
              // Fallback to main collection if no pack is selected
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<CardCubit>().showMainCollection();
              });
              return const SizedBox.shrink();
            }

            return WillPopScope(
              onWillPop: () async {
                context.read<CardCubit>().showMainCollection();
                return false;
              },
              child: PackOpeningPage(
                pack: state.selectedPack!,
                onCardRevealed: (_) {},
                onClose: () => context.read<CardCubit>().showMainCollection(),
              ),
            );

          case CardPageView.collection:
            return MainCollectionScreen(
              onCardTap: _inspectCard,
              onOpenNewPack: () => context.read<CardCubit>().showPackCarousel(),
              selectedCard: _selectedCard,
              cardInspectionOverlay: _selectedCard != null
                  ? AnimatedBuilder(
                      animation: _inspectAnimation,
                      builder: (context, child) {
                        return Positioned.fill(
                          child: GestureDetector(
                            onTap: _closeInspection,
                            child: Container(
                              color: Colors.black
                                  .withOpacity(0.8 * _inspectAnimation.value),
                              alignment: Alignment.center,
                              child: Transform.scale(
                                scale: 0.8 + (0.2 * _inspectAnimation.value),
                                child: Hero(
                                  tag: 'card_${_selectedCard?.name}',
                                  child: CardDetail(
                                    card: _selectedCard!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : null,
            );
        }
      },
    );
  }
}
